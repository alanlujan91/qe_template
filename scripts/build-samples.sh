#!/usr/bin/env bash
#
# Build every sample export and verify the PDFs are real, current, and typeset
# with the right journal's bibliography style.
#
# This exists because `myst build` exits 0 on a broken build, so a hook that
# checks only its exit status reports success on a document that failed to
# typeset. Reading the exit code is not enough; neither, it turns out, is
# reading the logs.
#
# Three things had to be measured rather than assumed, and each one changed the
# design:
#
#   1. A MISSING or unreadable .bst produces no error anywhere. myst exits 0,
#      the LaTeX logs stay clean, and no .blg survives to grep, because the
#      failure is BibTeX's rather than LaTeX's. The PDF is produced with its
#      bibliography silently absent. Only the artifact shows it.
#   2. A WRONG but valid .bst is invisible to that check. Feeding Econometrica's
#      econsoc.bst to a Theoretical Economics document yields a fully populated
#      bibliography, a clean log, a normal-size PDF, and every content assertion
#      passing, while the document is typeset in the wrong journal's style. That
#      is the exact failure this template's per-journal selection exists to
#      prevent, so the emitted \bibliographystyle is checked against what the
#      journal's own upstream template prescribes.
#   3. Validating whatever PDFs happen to be on disk is not the same as
#      validating this build's output. With no TeX toolchain installed, myst
#      still exits 0, produces nothing, and the previously committed PDFs sit
#      there satisfying every assertion. So the export directory is cleared
#      first and the expected count asserted.
#
# Building both sources covers all three journals, since each source carries one
# export per journal. Econometrica and Theoretical Economics are compiled here
# and nowhere else: CI has no TeX toolchain by design.

set -euo pipefail

cd "$(dirname "$0")/.."

# shellcheck source=scripts/lib-econsoc.sh
. "$(dirname "$0")/lib-econsoc.sh"

SOURCES=(article.md supplement.md)

# The bibliography check is the only thing that catches a dead bibliography, and
# it guards ecta and te, which nothing else compiles. A machine without
# poppler-utils must therefore fail rather than quietly skip it: a gate that
# degrades to nothing is indistinguishable from a gate that passed.
command -v pdftotext >/dev/null 2>&1 ||
    die "pdftotext not found (install poppler-utils); the bibliography check cannot run without it"

# Every export declared across the sources: this is what the build owes us.
expected=$(grep -hcE '^ *output: exports/.*\.pdf$' sample/"${SOURCES[0]}" sample/"${SOURCES[1]}" | paste -sd+ | bc)

# Clear first, so nothing below can validate a leftover from an earlier run.
# myst does not overwrite an export file that already exists, which is what let
# the vendored copies rot a full class release behind, so a stale export here
# would survive a rebuild and pass every assertion.
rm -rf sample/exports

echo "Building ${SOURCES[*]} ($expected exports expected)"
( cd sample && myst build "${SOURCES[@]}" --pdf )

status=0

shopt -s nullglob
logs=(sample/exports/*_pdf_logs/*.log sample/exports/*_pdf_tex/*.log)
pdfs=(sample/exports/*.pdf)
texs=(sample/exports/*_pdf_tex/*.tex)
shopt -u nullglob

if [ "${#pdfs[@]}" -ne "$expected" ]; then
    die "expected $expected PDFs under sample/exports/, found ${#pdfs[@]} (is a TeX toolchain installed?)"
fi

# The logs array needs the same zero-guard as the PDFs. Without it a renamed log
# directory makes the loop below a no-op while the summary still reports success.
if [ "${#logs[@]}" -eq 0 ]; then
    die "no LaTeX logs found under sample/exports/, so the log check would cover nothing"
fi

# Read the logs, not the exit code. This catches genuine LaTeX errors; it does
# NOT catch the bibliography failures above, which never reach a .log.
for log in "${logs[@]}"; do
    if grep -qE '^! |LaTeX Error|I could(n.t| not) open style file|Emergency stop' "$log"; then
        echo "ERROR: LaTeX reported a failure in $log" >&2
        grep -nE '^! |LaTeX Error|I could(n.t| not) open style file|Emergency stop' "$log" | head -5 >&2
        status=1
    fi
done

# Assert each export names the style its journal's own upstream template
# prescribes. This is what distinguishes "a bibliography rendered" from "the
# right journal's bibliography rendered".
for tex in "${texs[@]}"; do
    journal=$(sed -n 's/^\\documentclass\[\([a-z]*\),.*/\1/p' "$tex" | head -1)
    emitted=$(sed -n 's/^\\bibliographystyle{\([^}]*\)}.*/\1/p' "$tex" | head -1)

    if [ -z "$journal" ] || [ -z "$emitted" ]; then
        echo "ERROR: could not read the class option or bibliography style from $tex" >&2
        status=1
        continue
    fi

    expected_style=$(journal_bst "$journal")
    if [ "$emitted" != "$expected_style" ]; then
        printf 'ERROR: %s targets %s and emits \\bibliographystyle{%s},\n' "$tex" "$journal" "$emitted" >&2
        echo "       but $journal upstream prescribes $expected_style" >&2
        status=1
    fi
done

# Ask the artifact whether the bibliography is actually there. 'Aumann' reaches
# the PDF only through a resolved citation: it appears in references.bib and
# nowhere in the sample prose, so it cannot be satisfied by body text.
for pdf in "${pdfs[@]}"; do
    size=$(wc -c < "$pdf")
    if [ "$size" -lt 10000 ]; then
        echo "ERROR: $pdf is only $size bytes, too small to be a real document" >&2
        status=1
    fi

    refs=$(pdftotext "$pdf" - 2>/dev/null | grep -c 'Aumann' || true)
    if [ "$refs" -lt 3 ]; then
        echo "ERROR: $pdf resolved $refs bibliography references, expected at least 3." >&2
        echo "       BibTeX produced nothing or only part of the bibliography, which" >&2
        echo "       usually means the .bst is missing, unreadable, or not shipped." >&2
        status=1
    fi
done

if [ "$status" -eq 0 ]; then
    printf 'OK: %d PDFs built and verified, %d logs clean\n' "${#pdfs[@]}" "${#logs[@]}"
fi

exit "$status"
