#!/usr/bin/env bash
#
# Build every sample export and verify the PDFs are real.
#
# This exists because `myst build` exits 0 on a broken build. A hook that only
# checks its exit status reports success on a document that failed to typeset,
# so "catches LaTeX errors" has to be earned by reading the logs rather than the
# exit code. The signatures below include "I couldn't open style file", which is
# exactly what a missing or misnamed .bst produces: the failure this template's
# per-journal bibliography selection could otherwise introduce silently.
#
# Building both sources covers all three journals, since each source carries one
# export per journal. Econometrica and Theoretical Economics are compiled here
# and nowhere else: CI has no TeX toolchain by design.

set -euo pipefail

cd "$(dirname "$0")/../sample"

SOURCES=(article.md supplement.md)

echo "Building: ${SOURCES[*]}"
myst build "${SOURCES[@]}" --pdf

status=0

# Every LaTeX log, whichever export directory it landed in.
shopt -s nullglob
logs=(exports/*_pdf_logs/*.log exports/*_pdf_tex/*.log)
pdfs=(exports/*.pdf)
shopt -u nullglob

if [ "${#pdfs[@]}" -eq 0 ]; then
    echo "ERROR: no PDFs were produced under sample/exports/" >&2
    exit 1
fi

# Read the logs, not the exit code.
for log in "${logs[@]}"; do
    if grep -qE '^! |LaTeX Error|I could(n.t| not) open style file|Emergency stop' "$log"; then
        echo "ERROR: LaTeX reported a failure in $log" >&2
        grep -nE '^! |LaTeX Error|I could(n.t| not) open style file|Emergency stop' "$log" | head -5 >&2
        status=1
    fi
done

# A PDF that exists but holds nothing is the failure mode an exit code hides.
for pdf in "${pdfs[@]}"; do
    size=$(wc -c < "$pdf")
    if [ "$size" -lt 10000 ]; then
        echo "ERROR: $pdf is only $size bytes, which is too small to be a real document" >&2
        status=1
    fi
done

# Check the artifact, because nothing else reports this one. A broken or
# unreadable .bst does NOT fail the build: myst exits 0, the LaTeX logs stay
# clean, no .blg survives, and the PDF is produced with its bibliography
# silently missing. Measured, not assumed: replacing qe.bst with garbage
# yielded an article_qe.pdf containing zero references while every other
# export still had three, and every log was clean. Since the whole point of
# this template's per-journal handling is selecting the right .bst, a gate
# that cannot see that failure is not a gate.
if command -v pdftotext >/dev/null 2>&1; then
    for pdf in "${pdfs[@]}"; do
        refs=$(pdftotext "$pdf" - 2>/dev/null | grep -c 'Aumann' || true)
        if [ "$refs" -eq 0 ]; then
            echo "ERROR: $pdf contains no bibliography entries." >&2
            echo "       BibTeX produced nothing, which usually means the .bst named by" >&2
            echo "       template.tex is missing, unreadable, or not shipped in template.yml." >&2
            status=1
        fi
    done
else
    echo "note: pdftotext not found, skipping the bibliography check (install poppler-utils)." >&2
fi

if [ "$status" -eq 0 ]; then
    printf 'OK: %d PDFs built, %d logs clean\n' "${#pdfs[@]}" "${#logs[@]}"
fi

exit "$status"
