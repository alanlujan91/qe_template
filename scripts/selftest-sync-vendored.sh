#!/usr/bin/env bash
#
# Self-test for scripts/sync-vendored.sh.
#
# The drift guard has grown to nine independently-reasoned fail-closed paths,
# and its correctness is no longer obvious by reading it. Every one of those
# paths was verified once, by hand, in a scratch directory that no longer
# exists. That is not coverage: it is a memory. This script records those
# checks so a future edit that quietly disables one is caught.
#
# The property under test is narrow and specific: each mutation must make
# `--check` FAIL, with a message naming the reason. A guard that cannot fail
# protects nothing, so asserting the exit code alone is not enough - a script
# that exited 1 unconditionally would pass that. Each case therefore also
# asserts the diagnostic, which is what a human acts on.
#
# No test framework, by design: the repository has none, and adding one to test
# a shell script would be a larger change than the thing being tested.
#
#   scripts/selftest-sync-vendored.sh

set -uo pipefail

cd "$(dirname "$0")/.." || exit 1
REPO=$PWD

# For die(). Without this the guards below call a command that does not exist,
# which under `set -uo pipefail` (no -e, deliberately) prints "command not found"
# and carries on, so a setup failure would still go unreported.
# shellcheck source=scripts/lib-econsoc.sh
. "$REPO/scripts/lib-econsoc.sh"

pass=0
fail=0

# Build a disposable copy of everything sync-vendored.sh reads. Real submodule
# content, so the mutations below are applied to genuine upstream files rather
# than to fixtures that might drift from them.
make_scratch() {
    local dir
    dir=$(mktemp -d)

    mkdir -p "$dir/scripts" "$dir/original"
    cp "$REPO/scripts/sync-vendored.sh" "$dir/scripts/"
    cp "$REPO/scripts/lib-econsoc.sh" "$dir/scripts/"
    cp "$REPO/template.yml" "$dir/"
    cp "$REPO"/*.bst "$REPO"/econsocart.cls "$REPO"/econsocart.cfg "$dir/"

    # Setup failures are reported, not swallowed. This cp previously ended in
    # `2>/dev/null`, so seeding the scratch tree from an incomplete source (a
    # checkout where `git submodule update --init --recursive` has not run) failed
    # quietly and the mutation scenarios then failed for reasons that had nothing
    # to do with the mutation under test: four of nine reported "exited 1 but never
    # said ..." and the clean-tree control failed too, all pointing at the wrong
    # thing. A harness that misdiagnoses its own setup is worse than one that stops.
    local journal
    for journal in ecta qe te; do
        mkdir -p "$dir/original/$journal"
        cp "$REPO/original/$journal"/*.bst \
           "$REPO/original/$journal"/econsocart.cls \
           "$REPO/original/$journal"/econsocart.cfg \
           "$REPO/original/$journal/${journal}_template.tex" \
           "$dir/original/$journal/" \
           || die "could not seed the scratch tree from original/$journal (run: git submodule update --init --recursive)"
    done

    printf '%s' "$dir"
}

# <name> <expected message substring> <mutation function>
check() {
    local name=$1 expect=$2 mutate=$3
    local dir out rc

    # `die` inside make_scratch cannot abort this script, because make_scratch is
    # invoked in a command substitution and therefore runs in a subshell: the exit
    # only leaves the subshell. This script also runs without `set -e` by design,
    # so the failure has to be caught explicitly here or the harness carries on
    # against a half-populated scratch tree and blames the mutation under test.
    if ! dir=$(make_scratch); then
        die "scratch setup failed for '$name' (diagnostic above); the harness cannot trust any result"
    fi
    ( cd "$dir" && "$mutate" )

    out=$(cd "$dir" && ./scripts/sync-vendored.sh --check 2>&1)
    rc=$?
    rm -rf "$dir"

    if [ "$rc" -eq 0 ]; then
        printf 'FAIL  %-34s exited 0; the guard did not fire\n' "$name"
        fail=$((fail + 1))
        return
    fi

    if ! printf '%s' "$out" | grep -qF "$expect"; then
        printf 'FAIL  %-34s exited %d but never said "%s"\n' "$name" "$rc" "$expect"
        printf '%s\n' "$out" | sed 's/^/        /' | head -4
        fail=$((fail + 1))
        return
    fi

    printf 'ok    %-34s exit %d, reported: %s\n' "$name" "$rc" "$expect"
    pass=$((pass + 1))
}

mutate_root_drift()      { echo '% drift' >> econsocart.cls; }
mutate_unparseable()     { sed -i 's/^\\ProvidesClass{econsocart}.*/\\ProvidesClass{econsocart}/' original/ecta/econsocart.cls; }
mutate_missing_file()    { rm -f original/te/econsocart.cls; }
mutate_tie_differs()     {
    # Make ecta and qe tie on the newest date with differing content.
    sed -i 's#\[2025/03/07#[2026/02/12#' original/qe/econsocart.cls
    echo '% divergent' >> original/qe/econsocart.cls
}
mutate_cfg_superseded()  { sed -i 's#\[2025/10/14#[2099/01/01#' original/qe/econsocart.cfg; }
mutate_style_collision() { sed -i 's/%\\bibliographystyle{te}/%\\bibliographystyle{qe}/' original/te/te_template.tex; cp original/qe/qe.bst original/te/qe.bst; }
mutate_yml_mismatch()    { sed -i '/^  - te\.bst$/d' template.yml; }
mutate_export_missing()  { mkdir -p sample/exports/x_pdf_tex; cp econsocart.cfg qe.bst te.bst econsoc.bst sample/exports/x_pdf_tex/; }
mutate_export_stale()    {
    mkdir -p sample/exports/x_pdf_tex
    cp econsocart.cls econsocart.cfg qe.bst te.bst econsoc.bst sample/exports/x_pdf_tex/
    echo '% stale' >> sample/exports/x_pdf_tex/econsocart.cls
}

echo "Self-testing scripts/sync-vendored.sh --check"
echo

check "root file drifted"          "DRIFT"                            mutate_root_drift
check "version date unparseable"   "cannot parse a version date"      mutate_unparseable
check "submodule file missing"     "missing original/te"              mutate_missing_file
check "newest date tie, differing" "resolve by hand"                  mutate_tie_differs
check "config superseded upstream" "release trains have diverged"     mutate_cfg_superseded
check "two journals, one style"    "silently overwrite"               mutate_style_collision
check "template.yml out of step"   "does not match the styles"        mutate_yml_mismatch
check "export copy missing"        "MISSING"                          mutate_export_missing
check "export copy stale"          "STALE"                            mutate_export_stale

echo
printf '%d passed, %d failed\n' "$pass" "$fail"

# A clean tree must still pass, or every case above proves nothing: a guard that
# always fails is as useless as one that never does.
if ! ./scripts/sync-vendored.sh --check >/dev/null 2>&1; then
    echo "FAIL  the unmutated repository does not pass --check" >&2
    fail=$((fail + 1))
else
    echo "ok    the unmutated repository still passes"
fi

[ "$fail" -eq 0 ]
