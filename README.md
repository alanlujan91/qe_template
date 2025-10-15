# Quantitative Economics

My official template for science!

![](thumbnail.png)

- Author: Alan Lujan (Unofficial)
- Author Website: https://example.com
- [Submission Guidelines](https://example.com/author-guidelines/latex-submission)

## Template Features

This template includes:

- Full support for Quantitative Economics journal formatting
- Author and affiliation management matching the econsocart class structure  
- Abstract and acknowledgement sections
- Bibliography integration with qe.bst style
- Draft/final document options
- Appendix support
- All required class files (econsocart.cls, econsocart.cfg, qe.bst)

## Usage

To use this template with your manuscript:

```bash
myst build your-document.md --pdf
```

Your frontmatter should include:

```yaml
title: Your Paper Title
short_title: Running Head Title
authors:
  - name:
      given: First
      surname: Author
    email: first@example.com
    affiliations: ["aff1"]
affiliations:
  - id: aff1
    department: Department Name
    institution: University Name
keywords:
  - keyword1
  - keyword2
tags:
  - JEL code 1
  - JEL code 2
bibliography: references.bib
```

## Testing

A complete working example is available in `sample/qe_sample.md`.

## MyST Implementation Details

### Approach

This template balances **MyST native features** with **raw LaTeX** to stay as close as possible to the official Quantitative Economics template while maintaining good authoring experience.

### Where We Use MyST Native Features

#### Typography
- **Emphasis**: Use `*italic*` and `**bold**` instead of `\textit{}` and `\textbf{}`
- **Math**: Standard MyST math with `$...$` and `$$...$$`
- **Inline code**: Use backticks for `\verb|...|` commands
- **Headings**: Use markdown `#`, `##`, `###` for sections

#### Citations
- `{cite:t}\`ref\`` for textual citations -> `\citet{ref}`
- `{cite:author}\`ref\`` for author-only citations
- `{cite:year}\`ref\`` for year-only citations
- Small formatting differences are acceptable (e.g., spacing, punctuation)

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

#### Figures & Cross-References
- Use `{figure}` directive for figures with captions
- Use `{numref}` role for cross-referencing equations, figures, tables, sections, and theorems
- MyST handles automatic numbering and reference formatting

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

#### Author/Affiliation Block
- Handled via template.tex with proper `\author[]{}` and `\address[]{}` commands
- **Reason**: Requires exact format for journal production system

### Known Acceptable Differences

When comparing the MyST-generated LaTeX output to the original QE template, the following differences are expected and acceptable:

#### Formatting & Spacing
1. **Line breaks/spacing**: MyST normalizes whitespace (double spaces after periods to single spaces, line wrapping differs)
2. **Paragraph formatting**: Content is identical but may reflow differently

#### Citations
3. **Citation commands**: MyST converts citation roles to LaTeX commands:
   - `{cite:author}` becomes `\citet{}` (original uses `\citeauthor{}`)
   - `{cite:year}` becomes `\citet{}` (original uses `\citeyear{}`)
   - Citation spacing: `{b2,b3,b4}` becomes `{b2, b3, b4}` (spaces added after commas)
   - **Workaround**: Use raw LaTeX `\citeauthor{}` and `\citeyear{}` directly if exact match required

#### Theorem Environments
4. **Theorem numbering**: MyST auto-generates section-numbered theorems:
   - MyST: `\newtheorem{theorem}{Theorem}[section]` produces "Theorem 1.1"
   - Original: `\newtheorem{theorem}{Theorem}` produces "Theorem 1"
   - Template keeps standard environments (`claim`, `fact`) for raw LaTeX usage
   - This affects all proof directives (`{prf:theorem}`, `{prf:lemma}`, etc.)

#### Figures & Tables
5. **Figure paths**: MyST copies figures to `files/` with content-hash filenames
   - Original: `\includegraphics{figure_sample}`
   - MyST: `\includegraphics[width=0.7\linewidth]{files/figure_sample-<hash>.pdf}`
6. **Table legends**: MyST doesn't support `\legend{}` command inside tables
   - **Workaround**: Use `**Table note:**` paragraph after table (as in sample)

#### Package Management
7. **Preamble additions**: MyST adds explicit imports:
   ```latex
   \usepackage{amsmath}
   \usepackage{amsthm}
   \usepackage{graphicx}
   \usepackage{natbib}
   ```
8. **Equation environments**: MyST uses `align` instead of `eqnarray` (modern best practice)

#### What Works Correctly
- **Short quotations**: Markdown `>` blockquotes convert to `\begin{quote}`
- **Long quotations**: Raw LaTeX `\begin{quotation}` preserved
- **Funding section**: `acknowledgement:` frontmatter converts to `\begin{funding}`
- **Bibliography**: External `.bib` files via `\bibliography{}` command

### Template Validation

Run these checks to ensure template quality:

```bash
# Check template structure
uv run jtex check

# Build sample and compare
uv run myst build sample/qe_sample.md --pdf

# Start website preview
uv run myst start
```

### Priority Fixes

If LaTeX compilation errors occur, check these in order:
1. Author/affiliation structure in `template.tex`
2. Theorem environment definitions
3. Table structure (ensure all `\begin{table}` have matching `\end{table}`)
4. Bibliography references (ensure `main.bib` exists and is valid)

## Upstream Repository Tracking

This template tracks the official [Quantitative Economics LaTeX support files](https://github.com/vtex-soft/texsupport.econometricsociety-qe) via a git submodule in the `original/` directory. This ensures the template stays compatible with upstream updates to the econsocart class and style files.

### Cloning This Repository

When cloning this repository, initialize the submodule:

```bash
git clone --recurse-submodules https://github.com/alanlujan91/qe_template.git
```

Or if you've already cloned without submodules:

```bash
git submodule update --init --recursive
```

### Automatic Updates

This repository includes a GitHub Action that automatically checks for upstream updates every Monday at 9 AM UTC. When updates are detected, the action:

1. Updates the `original/` submodule
2. Copies the latest template files (`econsocart.cls`, `econsocart.cfg`, `qe.bst`)
3. Creates a pull request for review

You can also manually trigger this workflow from the Actions tab in GitHub.

### Manual Update

To manually pull the latest changes from the official QE template:

```bash
cd original
git pull origin main
cd ..

# Copy updated files
Copy-Item original/econsocart.cls econsocart.cls -Force
Copy-Item original/econsocart.cfg econsocart.cfg -Force
Copy-Item original/qe.bst qe.bst -Force

# Commit changes
git add original econsocart.cls econsocart.cfg qe.bst
git commit -m "Update to latest upstream QE template"
```
