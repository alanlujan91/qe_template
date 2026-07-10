---
title: Appendix
numbering:
  heading_1: true
  heading_2: true
---

(appA)=

# Title of the first appendix

Appendices are provided through the `parts.appendix` frontmatter. If there is only one appendix, then please refer to it in text as ... in [the Appendix](#appA). If there is more than one appendix, then please refer to them as ... in [Appendix A](#appA), [Appendix B](#appB), etc. A bare `@appA` renders the heading title rather than the letter (a [known MyST limitation](https://github.com/executablebooks/mystmd/issues/1924)), so type the letter in the link text.

(appB)=

# Title of the second appendix

(appB1)=

## First subsection of Appendix B

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard LaTeX commands for headings in a `{appendix}` environment. Headings and other objects will be numbered automatically.

```{math}
:label: path
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
```

Sample of cross-reference to formula {eq}`path` in [Appendix B.1](#appB1). Note that it is better to refer to [Appendix B.1](#appB1) as opposed to [Appendix B](#appB), because it is easier for the reader to locate the necessary place.
