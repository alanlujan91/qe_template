#!/usr/bin/env bash
#
# Shared helpers for the vendoring and build scripts.
#
# journal_bst lives here rather than in either script because both need it and a
# second copy would be a second place for the journal-to-style mapping to be
# wrong. The whole point of deriving it from upstream is that the mapping is
# stated in exactly one place; duplicating the derivation would give that up
# while looking like it had not.

die() {
    echo "ERROR: $*" >&2
    exit 1
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
