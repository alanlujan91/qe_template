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
