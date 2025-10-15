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
bibliography: your-refs.bib
```

## Testing

A complete working example is available in the `sample/` directory.

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
