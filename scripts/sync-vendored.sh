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
# upstream: qe.bst from qe, te.bst from te, econsoc.bst from ecta.
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

die() {
    echo "ERROR: $*" >&2
    exit 1
}

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

# Echo the BibTeX style name a journal's own upstream template prescribes, read
# from its `\bibliographystyle{...}` line. Upstream ships that line commented
# out (authors uncomment it), hence the leading `%*`.
journal_bst() {
    local journal=$1
    local template="original/$journal/${journal}_template.tex"
    local style

    [ -f "$template" ] || die "missing $template (run: git submodule update --init --recursive)"

    style=$(sed -n '/^%*\\bibliographystyle{/{
        s/^%*\\bibliographystyle{\([A-Za-z0-9._-]*\)}.*/\1/p
        q
    }' "$template")

    [ -n "$style" ] || die "cannot determine the bibliography style from $template"
    printf '%s' "$style"
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
for journal in "${JOURNALS[@]}"; do
    if [ "$journal" = "$shared_submodule" ]; then
        continue
    fi

    other_cfg_date=$(provides_date "original/$journal/econsocart.cfg")
    if [[ "$other_cfg_date" > "$chosen_cfg_date" ]]; then
        die "econsocart.cfg: $journal ships $other_cfg_date, newer than $shared_submodule's $chosen_cfg_date, but the class is newest in $shared_submodule; resolve by hand"
    fi
done

sync_one econsocart.cls "$shared_submodule" "newest class, dated $shared_date"
sync_one econsocart.cfg "$shared_submodule" "paired with the class from the same release"

# Each journal's bibliography style is read from that journal's OWN upstream
# template rather than a table maintained here. A hardcoded map would be
# checked only against itself: --check would re-derive its expectation from the
# same table it is meant to guard, so a swapped or mistyped entry would copy the
# wrong journal's .bst and stay green forever. Deriving it means a wrong mapping
# is not expressible.
for journal in "${JOURNALS[@]}"; do
    style=$(journal_bst "$journal")
    sync_one "$style.bst" "$journal" "bibliography style declared by $journal upstream"
done

if [ "$mode" = "--check" ]; then
    if [ "$status" -eq 0 ]; then
        echo "All vendored files match the pinned submodules."
    else
        echo "Re-sync with: scripts/sync-vendored.sh" >&2
    fi
fi

exit "$status"
