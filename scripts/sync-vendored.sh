#!/usr/bin/env bash
#
# Sync the vendored Econometric Society files from the pinned original/* submodules.
#
# econsocart.cls and econsocart.cfg are ONE shared file used by all three
# journals. The three upstreams re-release it independently and at different
# times, so there is no fixed "correct" source: whichever submodule ships the
# newest \ProvidesClass / \ProvidesFile date wins. As of this writing that is
# ecta (class 2026/02/12 v1.4.25), but qe or te may take the lead next release
# and this script will follow without needing an edit.
#
# The .bst files are genuinely journal-specific and always come from their own
# upstream, under whichever style name that journal's own template prescribes.
# The names are DERIVED, not listed here (see journal_bst below): writing them
# down would recreate the fixed table this script exists to avoid trusting.
# They currently resolve to econsoc.bst, qe.bst and te.bst.
#
# Usage:
#   scripts/sync-vendored.sh           copy the correct sources to the repo root
#   scripts/sync-vendored.sh --check   verify the root copies match (CI drift guard)

set -euo pipefail

cd "$(dirname "$0")/.."

# Submodules to consider when choosing the newest shared class/cfg.
JOURNALS=(ecta qe te)

mode=${1:-sync}
if [ "$mode" != "sync" ] && [ "$mode" != "--check" ]; then
    echo "usage: $0 [--check]" >&2
    exit 2
fi

status=0

# die() and journal_bst() are shared with build-samples.sh, which needs the same
# journal-to-style derivation. A second copy would be a second place for the
# mapping to go wrong.
# shellcheck source=scripts/lib-econsoc.sh
. "$(dirname "$0")/lib-econsoc.sh"

# Extract the LaTeX file date (YYYY/MM/DD) from a \Provides... declaration.
# The date is zero-padded, so plain string comparison orders releases correctly
# and we never have to parse the vX.Y.Z version numerically.
# Quits at the first match rather than piping to `head -1`: under `set -o
# pipefail` a second matching line would make head exit first, hand sed a
# SIGPIPE, and fail the assignment with no message at all.
provides_date() {
    sed -n '/^\\Provides[A-Za-z]*{econsocart/{
        s/^[^[]*\[\([0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\).*/\1/p
        q
    }' "$1"
}

# Echo "<submodule> <date>" for whichever journal ships the newest copy of a
# shared file. Fails loudly if two submodules claim the same date but differ in
# content, which would mean upstream shipped divergent files under one version.
newest_source() {
    local relname=$1
    local best="" best_date="" journal file date

    # Pass 1: find the newest date. Content is deliberately NOT compared here.
    # Two journals tying on a date that a third one beats is irrelevant, and
    # comparing during the scan would abort on such a tie purely because of
    # iteration order, before the real winner was ever reached.
    for journal in "${JOURNALS[@]}"; do
        file="original/$journal/$relname"
        [ -f "$file" ] || die "missing $file (run: git submodule update --init --recursive)"

        date=$(provides_date "$file")
        [ -n "$date" ] || die "cannot parse a version date from $file"

        if [ -z "$best_date" ] || [[ "$date" > "$best_date" ]]; then
            best=$journal
            best_date=$date
        fi
    done

    # Pass 2: everything tied at the WINNING date must agree byte for byte.
    # A real tie there means upstream shipped divergent files under one version,
    # and there is no defensible way to choose between them.
    for journal in "${JOURNALS[@]}"; do
        if [ "$journal" = "$best" ]; then
            continue
        fi

        file="original/$journal/$relname"
        date=$(provides_date "$file")

        if [ "$date" = "$best_date" ] && ! diff -q "original/$best/$relname" "$file" >/dev/null; then
            die "$relname: $best and $journal are both dated $best_date but differ; resolve by hand"
        fi
    done

    printf '%s %s' "$best" "$best_date"
}

# Copy (or, in --check mode, verify) one vendored file against its source.
sync_one() {
    local root=$1 submodule=$2 label=$3
    local src="original/$submodule/$root"

    [ -f "$src" ] || die "missing $src (run: git submodule update --init --recursive)"

    if [ "$mode" = "--check" ]; then
        if diff -q "$src" "$root" >/dev/null 2>&1; then
            printf 'OK     %-16s <- original/%-4s  (%s)\n' "$root" "$submodule" "$label"
        else
            printf 'DRIFT  %-16s != original/%-4s  (%s)\n' "$root" "$submodule" "$label"
            diff "$src" "$root" || true
            status=1
        fi
    else
        cp "$src" "$root"
        printf 'synced %-16s <- original/%-4s  (%s)\n' "$root" "$submodule" "$label"
    fi
}

# Both shared files come from ONE submodule. Upstream releases econsocart.cls
# and econsocart.cfg together, so selecting each independently could pair a
# newer class from one journal with a newer config from another - a combination
# upstream never released and nobody has ever compiled.
#
# Assign on its own line before reading. `read ... <<<"$(newest_source ...)"`
# takes read's exit status, not the command substitution's, so a die() inside
# newest_source would kill only the subshell and execution would carry on with
# empty values. A plain assignment lets set -e see the failure and abort.
selection=$(newest_source econsocart.cls)
read -r shared_submodule shared_date <<<"$selection"
if [ -z "$shared_submodule" ] || [ -z "$shared_date" ]; then
    die "could not determine the newest source for econsocart.cls"
fi

# Taking the pair from one journal must not silently ship a config that another
# journal has already superseded. If that happens the release trains have
# diverged and a human has to decide which pairing to trust.
chosen_cfg_date=$(provides_date "original/$shared_submodule/econsocart.cfg")
[ -n "$chosen_cfg_date" ] || die "cannot parse a version date from original/$shared_submodule/econsocart.cfg"

for journal in "${JOURNALS[@]}"; do
    if [ "$journal" = "$shared_submodule" ]; then
        continue
    fi

    other_cfg_date=$(provides_date "original/$journal/econsocart.cfg")
    if [[ "$other_cfg_date" > "$chosen_cfg_date" ]]; then
        conflict="econsocart.cfg: $journal ships $other_cfg_date, newer than $shared_submodule's $chosen_cfg_date, while the class is newest in $shared_submodule.
       The release trains have diverged: taking the pair from $shared_submodule ships a config upstream has already superseded, and taking $journal's config pairs it with a class it was never released against. Decide which pairing to trust, then pin the submodules accordingly."

        # Hard-fail only when CHECKING. Dying here in sync mode would abort the
        # scheduled sync job before it can open a pull request, and nobody
        # watches a red scheduled run: the signal a human needs would arrive as
        # silence. Syncing anyway produces a reviewable PR that says so.
        if [ "$mode" = "--check" ]; then
            die "$conflict"
        fi

        echo "WARNING: $conflict" >&2
    fi
done

managed=(econsocart.cls econsocart.cfg)

sync_one econsocart.cls "$shared_submodule" "newest class, dated $shared_date"
sync_one econsocart.cfg "$shared_submodule" "paired with the class from the same release"

# Each journal's bibliography style is read from that journal's OWN upstream
# template rather than a table maintained here. A hardcoded map would be
# checked only against itself: --check would re-derive its expectation from the
# same table it is meant to guard, so a swapped or mistyped entry would copy the
# wrong journal's .bst and stay green forever. Deriving it means a wrong mapping
# is not expressible.
declare -A style_owner=()
for journal in "${JOURNALS[@]}"; do
    style=$(journal_bst "$journal")

    # Two journals resolving to the same filename would make the second copy
    # overwrite the first, and would orphan the loser's .bst at the repo root:
    # still present, no longer in `managed`, so never checked again.
    if [ -n "${style_owner[$style]:-}" ]; then
        die "$style.bst: both ${style_owner[$style]} and $journal declare bibliographystyle{$style}; one would silently overwrite the other"
    fi
    style_owner[$style]=$journal

    sync_one "$style.bst" "$journal" "bibliography style declared by $journal upstream"
    managed+=("$style.bst")
done

# The derived set is only worth having if the things that actually SHIP agree
# with it. jtex copies exactly what template.yml lists, so a style derived here
# but absent there can never be used, and a style listed there but no longer
# derived is a stale file nothing checks. Reconciling makes "a wrong mapping is
# not expressible" true of the repository rather than only of this script.
listed_bst=$(sed -n '/^files:/,/^[a-z]/{s/^  *- *\(.*\.bst\) *$/\1/p;}' template.yml | sort)
derived_bst=$(printf '%s\n' "${managed[@]}" | grep '\.bst$' | sort)

if [ "$listed_bst" != "$derived_bst" ]; then
    echo "ERROR: template.yml files: does not match the styles declared upstream" >&2
    echo "  template.yml lists : $(printf '%s' "$listed_bst" | tr '\n' ' ')" >&2
    echo "  upstream declares  : $(printf '%s' "$derived_bst" | tr '\n' ' ')" >&2
    echo "  Update the files: list in template.yml, or jtex will ship the wrong set." >&2
    status=1
fi

# Report any .bst at the root that no journal declares. After an upstream style
# rename the old file stays behind: outside `managed`, so never synced and never
# checked again, while still satisfying every file-exists check. It is inert
# once template.yml stops listing it, but it is dead weight that looks live, and
# nothing else would ever mention it.
shopt -s nullglob
for bst in ./*.bst; do
    bst=${bst#./}
    case " ${managed[*]} " in
        *" $bst "*) continue ;;
    esac

    echo "note: $bst is not declared by any journal upstream; it is no longer synced or checked." >&2
    echo "      If an upstream style was renamed, this is the superseded file and can be deleted." >&2
done
shopt -u nullglob

# Each built export directory holds its own copy of every file above, and
# `myst build` does not overwrite an export copy that already exists. Those
# copies therefore do not follow a re-vendor on their own: they once sat at
# class v1.4.20 while the root shipped v1.4.25, so a PDF built from them was
# typeset against a class the template no longer ships. The directories are no
# longer tracked, so that can no longer reach a reviewer, but it can still
# reach a local build, and scripts/build-samples.sh now clears them before
# building for the same reason.
#
# nullglob, so a non-matching pattern yields nothing rather than the literal
# string. The predecessor of this loop paired an unguarded glob with
# `[ -d "$dir" ] || continue`, and when the export directories moved under
# sample/exports/ the glob stopped matching, the loop stopped running, and
# --check still reported that everything matched: the coverage evaporated
# silently, which is the defect class this section exists to catch. The
# explicit zero-count note below is what replaces that guard.
shopt -s nullglob
export_dirs=(sample/exports/*_pdf_tex)
shopt -u nullglob

if [ "${#export_dirs[@]}" -eq 0 ]; then
    echo "note: no built exports under sample/exports/, so only the root copies were checked."
fi

for export_dir in "${export_dirs[@]}"; do
    for root in "${managed[@]}"; do
        if [ ! -f "$export_dir/$root" ]; then
            # A built export directory should hold every managed file, because
            # jtex copies exactly template.yml's files: list into it. One that is
            # absent means the export is incomplete and would not compile
            # standalone. Skipping silently here would let sync mode pass over
            # the very file it needs to create.
            if [ "$mode" = "--check" ]; then
                printf 'MISSING %-15s from %s\n' "$root" "$export_dir"
                status=1
            else
                cp "$root" "$export_dir/$root"
                printf 'restored %-15s -> %s\n' "$root" "$export_dir/$root"
            fi
            continue
        fi

        if [ "$mode" = "--check" ]; then
            if diff -q "$root" "$export_dir/$root" >/dev/null 2>&1; then
                printf 'OK     %-16s == %s\n' "$root" "$export_dir/$root"
            else
                printf 'STALE  %-16s != %s\n' "$root" "$export_dir/$root"
                echo '       (myst build will not overwrite an existing export copy; delete it and rebuild, or re-run this script without --check)' >&2
                status=1
            fi
        else
            cp "$root" "$export_dir/$root"
            printf 'synced %-16s -> %s\n' "$root" "$export_dir/$root"
        fi
    done
done

if [ "$mode" = "--check" ]; then
    if [ "$status" -eq 0 ]; then
        echo "All vendored files match the pinned submodules."
    else
        echo "Re-sync with: scripts/sync-vendored.sh" >&2
    fi
fi

exit "$status"
