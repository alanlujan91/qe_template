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
- **Document parts**: Abstract, acknowledgements/funding, appendix (as frontmatter parts)
- **Bibliography**: BibTeX integration with `qe.bst` style
- **Supplement support**: Supplementary material via `supplement` option
- **Template options**: Draft/final modes, line numbers, section-based equation numbering
- **Open access**: Set `open_access: true` in frontmatter to enable the econsocart class option

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
  appendix: qe_appendix.md
---

# Introduction

Your content here...
```

### 3. Build PDF

```bash
myst build paper.md --pdf
```

### 4. See Complete Examples

- Main article: [`sample/qe_sample.md`](sample/qe_sample.md)
- Supplementary material: [`sample/qe_supp_sample.md`](sample/qe_supp_sample.md)

## Template Options

Configure via `exports` in frontmatter:

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `draft` | boolean | `false` | Draft mode for initial submission |
| `supplement` | boolean | `false` | Supplementary material document |
| `seceqn` | boolean | `false` | Number equations by section (e.g., Equation 2.1) |
| `linenumbers` | boolean | `false` | Display line numbers (useful during review) |

The `open_access` frontmatter field automatically enables the econsocart `openaccess` class option.

Example with options:

```yaml
exports:
  - format: tex+pdf
    template: https://github.com/alanlujan91/qe_template
    output: paper.pdf
    draft: true
    linenumbers: true
```

**Note**: Use `acknowledgement` (singular) in frontmatter, not `acknowledgements`.

## MyST Implementation Details

### Approach

This template uses MyST native features wherever possible and falls back to raw LaTeX only for complex tables that exceed MyST's formatting capabilities.

### MyST Native Features

#### Typography

- **Emphasis**: `*italic*` and `**bold**` instead of `\textit{}` and `\textbf{}`
- **Math**: Standard MyST math with `$...$` and `` ```math `` blocks
- **Inline code**: Backticks for `\verb|...|` commands
- **Headings**: Markdown `#`, `##`, `###` for sections
- **Note**: Other text styles (small caps, sans serif) require inline LaTeX: `\textsc{}`, `\textsf{}`

#### Citations

- `` {cite:t}`ref` `` for textual citations (e.g., "Smith (2020)") renders as `\citet{}`
- `` {cite:p}`ref` `` for parenthetical citations (e.g., "(Smith 2020)") renders as `\citep{}`
- These are the only two citation roles officially supported by MyST. See [MyST Citations Guide](https://mystmd.org/guide/citations).

#### Lists

- Itemized lists: Markdown `-` syntax
- Numbered lists: Markdown `1.`, `2.`, etc.

#### Footnotes

- Markdown footnote syntax: `[^1]` with `[^1]: Footnote text.` at the bottom

#### Quotations

- Markdown blockquote syntax with `>` prefix
- MyST converts to `\begin{quote}` in LaTeX
- See [MyST Typography Guide](https://mystmd.org/guide/typography#quotations)

#### Theorem-like Environments

MyST proof directives that produce correct LaTeX output:

| MyST Directive | LaTeX Environment |
| --- | --- |
| `{prf:theorem}` | `\begin{theorem}` |
| `{prf:lemma}` | `\begin{lemma}` |
| `{prf:proposition}` | `\begin{proposition}` |
| `{prf:corollary}` | `\begin{corollary}` |
| `{prf:definition}` | `\begin{definition}` |
| `{prf:example}` | `\begin{example}` |
| `{prf:remark}` | `\begin{remark}` |
| `{prf:axiom}` | `\begin{axiom}` |
| `{prf:conjecture}` | `\begin{conjecture}` |
| `{prf:observation}` | `\begin{observation}` |
| `{prf:proof}` | `\begin{proof}` |

The template fixes MyST's default section-based numbering (Theorem 1.1) to use global counters (Theorem 1) as required by QE.

**Note**: `claim` and `fact` are not supported by MyST's proof directives. The sample uses `{prf:proposition}` and `{prf:observation}` as substitutes.

See [MyST Proofs & Theorems](https://mystmd.org/guide/proofs-and-theorems) for details.

#### Appendices

Appendices are handled through the `parts` frontmatter:

```yaml
parts:
  appendix: qe_appendix.md
```

The template wraps the content in `\begin{appendix}...\end{appendix}` and promotes headings to the correct level (MyST demotes part content by one level, which the template corrects).

The `appendix.md` file is plain MyST with no raw LaTeX needed:

```markdown
---
title: Appendix
numbering:
  heading_1: true
  heading_2: true
---

(appA)=

# Title of first appendix

Content here...
```

#### Equations

- Inline math: `$...$`
- Display math: `` ```math `` blocks with optional `:label:` for numbered equations
- Multi-line equations with a single number: use `\begin{aligned}` inside a `{math}` block with `:label:`
- Equation arrays: use `\begin{align}` inside a `` ```math `` block
- Reference equations with `` {eq}`label` ``

#### Cross-References

- **Theorems, Lemmas, etc.**: `@th1` renders as "Theorem 1" (`Theorem~\ref{th1}`)
- **Definitions**: `@de1` renders as "Definition 1"
- **Tables**: `` {numref}`my-table` `` renders as "Table 1"
- **Figures**: `` {numref}`my-fig` `` renders as "Figure 1"
- **Equations**: `` {eq}`label` `` renders as "(1)"
- **Sections**: `@s1` renders the section **title** (e.g., "Introduction"), not the number. This is a [known MyST limitation](https://github.com/executablebooks/mystmd/issues/1924).

See [MyST Cross-references Guide](https://mystmd.org/guide/cross-references) for complete details.

### Where We Use Raw LaTeX

#### Complex Tables

Tables with custom column specifications, `\hline`, `\cline`, `\legend{}`, and precise alignment require raw LaTeX `{raw} latex` blocks. MyST's table syntax cannot reproduce these layouts.

### Known Acceptable Differences

When comparing the MyST-generated LaTeX output to the original QE sample:

1. **Line breaks/spacing**: MyST normalizes whitespace differently
2. **Section cross-references**: `@label` renders section titles instead of numbers
3. **Figure paths**: MyST copies figures to `files/` with content-hash filenames
4. **Preamble additions**: MyST adds `amsmath`, `amsthm`, `graphicx`, `natbib` alongside template packages

## Supplement Template

For supplementary material, use the same template with `supplement: true`:

```yaml
exports:
  - format: tex+pdf
    template: https://github.com/alanlujan91/qe_template
    output: supplement.pdf
    supplement: true
```

In supplement mode, the template skips funding, coeditor, keywords, and JEL code sections. Abstract is optional. See [`sample/qe_supp_sample.md`](sample/qe_supp_sample.md) for a working example.

## Local Development

### Preview Website

```bash
myst start
```

### Build PDF

```bash
myst build your-paper.md --pdf
```

### Troubleshooting

**LaTeX compilation errors**:

1. **Missing fonts**: The `econsocart` class requires Utopia fonts. Install with `tlmgr install utopia`.
2. **Missing bibliography**: Ensure `bibliography: file.bib` in frontmatter and the file exists.
3. **Author format**: Check name structure matches the example above.
4. **Citations**: Verify all `{cite:}` references have matching BibTeX entries.
5. **Math**: Ensure all `$` and `$$` are properly closed.

**Common issues**:

- **"Template not found"**: Check `exports` -> `template` path is correct
- **"Bibliography not found"**: Ensure `.bib` file is in the correct location

**Getting help**:

- Check [`sample/qe_sample.md`](sample/qe_sample.md) for a working example
- Review [MyST Documentation](https://mystmd.org)
- Open an [issue](../../issues) for template-specific problems

## Template Files

- `template.tex` - Main template file (Jinja2 syntax)
- `template.yml` - Template configuration and options
- `econsocart.cls` - QE document class
- `econsocart.cfg` - QE configuration
- `qe.bst` - QE bibliography style
- `thumbnail.png` - Template preview
- `sample/` - Complete working examples (main article and supplement)

## License

- **License**: CC-BY-4.0
- **Based on**: Official [Quantitative Economics LaTeX Template](https://github.com/vtex-soft/texsupport.econometricsociety-qe)
- **Journal**: [Quantitative Economics](https://qeconomics.org/)
- **MyST Tools**: [MyST Markdown](https://mystmd.org)

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](.github/CONTRIBUTING.md) for development setup, workflow documentation, and guidelines.
