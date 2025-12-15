# Quantitative Economics MyST Template

MyST Markdown template for Quantitative Economics journal submissions.

![QE Template Thumbnail](thumbnail.png)

- **Template**: [github.com/alanlujan91/qe_template](https://github.com/alanlujan91/qe_template)
- **Author**: Alan Lujan
- **Based on**: [Official QE LaTeX Template](https://github.com/vtex-soft/texsupport.econometricsociety-qe)
- **Journal**: [Quantitative Economics](https://qeconomics.org/)

## Features

- **Full QE journal support**: Uses official `econsocart` class with all required style files
- **MyST Markdown authoring**: Write in Markdown, compile to LaTeX/PDF
- **Author management**: Multiple authors and affiliations with proper formatting
- **Document parts**: Abstract, acknowledgements/funding, appendix
- **Bibliography**: BibTeX integration with `qe.bst` style
- **Draft/Final modes**: Toggle between submission and publication versions
- **Automated validation**: Pre-commit hooks and CI/CD ensure quality
- **Upstream tracking**: Automatic synchronization with official QE template updates

## Quick Start

### 1. Install MyST

```bash
npm install -g mystmd
# or
uv tool install mystmd
```

### 2. Create Your Document

Create a Markdown file with proper frontmatter:

```yaml
---
title: Your Paper Title
short_title: Running Head Title
date: 2025-01-15
license: CC-BY-4.0
open_access: true
exports:
  - format: tex+pdf
    template: https://github.com/alanlujan91/qe_template
    output: paper.pdf
    draft: true  # or final: true for publication
authors:
  - name:
      given: First
      surname: Author
    email: first@author.edu
    affiliations: ["aff1"]
  - name:
      given: Second
      surname: Author
    email: second@author.edu
    affiliations: ["aff2"]
affiliations:
  - id: aff1
    department: Department of Economics
    institution: First University
  - id: aff2
    department: Business School
    institution: Second University
keywords:
  - keyword 1
  - keyword 2
  - keyword 3
tags:
  - C00
  - D00
bibliography: references.bib
venue:
  title: Quantitative Economics
  url: https://qeconomics.org/
parts:
  abstract: |
    Your abstract here (max 150 words recommended).
    Should be clear, descriptive, and self-explanatory.
  acknowledgement: |
    We thank reviewers and acknowledge funding sources.
    Do not thank the editor by name.
---

# Introduction

Your content here...
```

### 3. Build PDF

```bash
myst build paper.md --pdf
```

### 4. See Complete Example

A working example is available in [`sample/qe_sample.md`](sample/qe_sample.md).

## Template Options

Configure via `exports` in frontmatter:

| Option  | Type    | Default | Description                       |
| ------- | ------- | ------- | --------------------------------- |
| `draft` | boolean | `true`  | Draft mode for initial submission |
| `final` | boolean | `false` | Final mode for prepublication     |

**Note**: Use `acknowledgement:` (singular) in frontmatter, not `acknowledgements`.

## MyST Implementation Details

### Approach

This template balances **MyST native features** with **raw LaTeX** to stay as close as possible to the official Quantitative Economics template while maintaining good authoring experience.

### Where We Use MyST Native Features

#### Typography

- **Emphasis**: Use `*italic*` and `**bold**` instead of `\textit{}` and `\textbf{}`
- **Math**: Standard MyST math with `$...$` and `$$...$$`
- **Inline code**: Use backticks for `\verb|...|` commands
- **Headings**: Use markdown `#`, `##`, `###` for sections
- **Note**: Other text styles (small caps, sans serif, etc.) require raw LaTeX: `\textsc{}`, `\textsf{}`, etc.

#### Citations

- `` {cite:t}`ref` `` for textual citations (e.g., "Smith (2020)") → `\citet{}`
- `` {cite:p}`ref` `` for parenthetical citations (e.g., "(Smith 2020)") → `\citep{}`
- **Note**: `{cite:author}` and `{cite:year}` do not work correctly in MyST (both map to `\citet{}`)
- **Workaround**: Use raw LaTeX commands directly: `\citeauthor{ref}` and `\citeyear{ref}`
- For citations with optional arguments (e.g., "Theorem 1"), use raw LaTeX: `\citet[Theorem 1]{ref}`

#### Lists

- **Simple lists**: Use markdown `-` for itemize
- **Simple numbered lists**: Use markdown `1.`, `2.`, etc.

#### Footnotes

- Use markdown footnote syntax `[^1]`

#### Short Quotations

- Use markdown blockquote syntax with `>` prefix for single-paragraph quotes
- MyST converts to `\begin{quote}` environment in LaTeX
- See [MyST Typography Guide](https://mystmd.org/guide/typography#quotations) for details

#### Theorem-like Environments

- Use MyST proof directives: `{prf:theorem}`, `{prf:proof}`, `{prf:lemma}`, `{prf:axiom}`, `{prf:definition}`, `{prf:example}`, `{prf:remark}`
- These automatically handle numbering and LaTeX output
- See [MyST Proofs & Theorems](https://mystmd.org/guide/proofs-and-theorems) for details
- **Note**: `claim` and `fact` environments use raw LaTeX (MyST doesn't support these)

#### Appendices

The appendix is included using MyST's `{include}` directive to preserve correct heading levels:

```markdown
```{include} appendix.md
```
```

The `appendix.md` file uses a raw LaTeX `\appendix` command at the top to switch LaTeX to appendix mode:

```markdown
---
title: Appendix
numbering:
  heading_1: true
  heading_2: true
---

```{raw} latex
\appendix
```

(appendix-a)=

# Title of first appendix

Content here...
```

**Why this approach:**
- Using `parts.appendix` causes MyST to demote headings (`#` → `\subsection` instead of `\section`)
- Using `{include}` preserves the original heading levels
- The `\appendix` raw block is minimal—just the command to switch LaTeX mode
- All other content uses native MyST syntax (headings, math, etc.)

#### Cross-References

MyST provides powerful cross-referencing, but **the syntax depends on whether the target is MyST-native or raw LaTeX**:

**Important**: In regular markdown text, `\ref{}` commands **only work inside `{raw} latex` blocks**. Use MyST cross-reference syntax instead: prefer `@label` shorthand (e.g., `@th1`), or use `{numref}`, `{eq}`, `{ref}` roles. **Exception**: `$\ref{label}$` in math mode passes through to LaTeX correctly (see section numbering workaround below).

**For MyST Native Elements** (use `@label` shorthand):
- **Theorems, Lemmas, Axioms, etc.**: `@th1` renders as `Theorem~\ref{th1}` → "Theorem 1.1"
- **Definitions**: `@de1` renders as `Definition~\ref{de1}` → "Definition 1"
- **Tables**: `@my-table` or `` {numref}`my-table` `` renders as "Table 1"
- **Figures**: `@my-fig` or `` {numref}`my-fig` `` renders as "Figure 1"
- **Sections**: `@s1` or `` {ref}`s1` `` renders as section title (e.g., "Introduction")
  - **Known Bug**: MyST's `{numref}` and `%s` placeholder for sections show titles instead of numbers in LaTeX export
  - See [mystmd#1924](https://github.com/executablebooks/mystmd/issues/1924) and [mystmd#1127](https://github.com/executablebooks/mystmd/issues/1127)
  - **Workaround**: Use `Section~$\ref{label}$` - the `\ref{}` inside math mode passes through to LaTeX correctly!
  - Example: `Section~$\ref{s1}$` → renders as "Section 1" in PDF

**For Equations**:
- **MyST equations**: Use `` {eq}`label` `` which renders as "(1)" in LaTeX
- **Both** MyST `{math}` blocks with `\label{}` and raw LaTeX equations work with `` {eq}`label` ``
- MyST generates `(\ref{label})` which LaTeX resolves regardless of where the label is defined
- Example: `` {eq}`e7` `` works for labels in both `{math}` blocks and raw LaTeX blocks

**For Raw LaTeX Elements**:
- **Claims, Facts** (raw LaTeX environments): Use `\ref{cl1}` **inside** raw LaTeX blocks
- Any label defined with `\label{}` inside raw LaTeX: Use `\ref{}` **inside** raw LaTeX blocks
- **Note**: For elements defined in raw LaTeX, reference them from raw LaTeX blocks. The `$\ref{}$` math mode workaround only works reliably for section/appendix numbering.

See [MyST Cross-references Guide](https://mystmd.org/guide/cross-references) for complete details.

### Where We Use Raw LaTeX

#### Complex Tables

- Tables with custom column specifications, `\hline`, `\cline`, etc.
- Tables requiring precise alignment and `\legend{}` commands
- **Reason**: MyST's table syntax is too limited for academic paper requirements

#### Custom Enumerated Lists

- Lists with manual labels like `\item[(i)]`, `\item[(ii)]`, `\item[(iii)]`
- **Reason**: MyST doesn't support custom enumeration labels (beyond starting number)

#### Long Quotations (multi-paragraph)

- Use raw LaTeX `\begin{quotation}...\end{quotation}` for multi-paragraph quotes
- **Reason**: MyST's blockquote syntax produces `\begin{quote}`, but longer quotes should use `\begin{quotation}` with paragraph indentation

#### Multi-line Equations (eqnarray, align)

- Use raw LaTeX blocks to preserve specific environments like `eqnarray`
- MyST converts `{math}` blocks to `align` by default
- **Reason**: Some journals require specific equation environments

#### Author/Affiliation Block

- Handled via template.tex with proper `\author[]{}` and `\address[]{}` commands
- **Reason**: Requires exact format for journal production system

### Known Acceptable Differences

When comparing the MyST-generated LaTeX output to the original QE template, the following differences are expected and acceptable:

#### Formatting & Spacing

1. **Line breaks/spacing**: MyST normalizes whitespace (double spaces after periods to single spaces, line wrapping differs)
2. **Paragraph formatting**: Content is identical but may reflow differently

#### Citation Differences

3. **Citation commands**: `{cite:author}` and `{cite:year}` incorrectly map to `\citet{}`. See [Citations](#citations) for workarounds.

#### Theorem Environments

4. **Theorem numbering**: MyST's `{prf:}` directives produce section-numbered theorems ("Theorem 1.1") instead of global numbering ("Theorem 1"). This is inherent to MyST and cannot be changed. Use raw LaTeX for all theorems if global numbering is required.

#### Cross-References

5. **Equation references**: MyST's `` {eq}`label` `` works for all equations regardless of where the label is defined. See [Cross-References](#cross-references) for details.

#### Figures & Tables

6. **Figure paths**: MyST copies figures to `files/` with content-hash filenames
   - Original: `\includegraphics{figure_sample}`
   - MyST: `\includegraphics[width=0.7\linewidth]{files/figure_sample-<hash>.pdf}`
7. **Table legends**: MyST doesn't support `\legend{}` command inside tables
   - **Workaround**: Use `**Table note:**` paragraph after table (as in sample)

#### Package & Environment Differences

8. **Preamble additions**: MyST adds explicit imports in addition to template-defined packages
   - Template includes: `amssymb`, `bm`, `etoolbox`, `fontenc`, `hyperref`, `textcomp`, `times`, `url`
   - MyST may add: `amsmath`, `amsthm`, `graphicx`, `natbib` as needed
   - See `packages:` list in [`template.yml`](template.yml)
9. **Equation environments**: MyST-native math blocks use `align`; use raw LaTeX blocks to preserve `eqnarray` or other specific environments.

## Local Development

### Preview Website

Preview website locally:

```bash
myst start
```

Build PDF manually:

```bash
myst build your-paper.md --pdf
```

### Troubleshooting

**LaTeX compilation errors**:

1. **Missing bibliography**: Ensure `bibliography: file.bib` in frontmatter and file exists
2. **Author format**: Check name structure matches example above
3. **Citations**: Verify all `{cite:}` references have matching BibTeX entries
4. **Math**: Ensure all `$` and `$$` are properly closed
5. **Tables**: Check all `\begin{table}` have matching `\end{table}`

**Common issues**:

- **"Template not found"**: Check `exports:` -> `template:` path is correct
- **"Bibliography not found"**: Ensure `.bib` file is in correct location

**Build warnings (safe to ignore)**:

- **"Unhandled TEX conversion for node of macro_LaTeX"**: The `\LaTeX` command in math mode; PDF generates correctly
- **"Unhandled TEX conversion for node of env_claim/env_fact"**: Custom environments in raw LaTeX blocks; they pass through correctly
- **"Replacing \begin{eqnarray} with \begin{align*}"**: MyST prefers `align` over `eqnarray`; use raw LaTeX blocks to preserve `eqnarray` if needed
- **"LaTeX reported an error"**: Check if PDF was actually generated—often these are just warnings

**Getting help**:

- Check [`sample/qe_sample.md`](sample/qe_sample.md) for working example
- Review [MyST Documentation](https://mystmd.org)
- Open an [issue](../../issues) for template-specific problems

## Template Files

- `template.tex` - Main template file (Jinja2 syntax)
- `template.yml` - Template configuration
- `econsocart.cls` - QE document class
- `econsocart.cfg` - QE configuration
- `qe.bst` - QE bibliography style
- `thumbnail.png` - Template preview
- `sample/` - Complete working example

## License

- **License**: CC-BY-4.0
- **Based on**: Official [Quantitative Economics LaTeX Template](https://github.com/vtex-soft/texsupport.econometricsociety-qe)
- **Journal**: [Quantitative Economics](https://qeconomics.org/)
- **MyST Tools**: [MyST Markdown](https://mystmd.org)

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](.github/CONTRIBUTING.md) for development setup, workflow documentation, and guidelines.
