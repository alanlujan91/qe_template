---
title: Appendix
numbering:
  heading_1: true
  heading_2: true
  heading_3: true
---

(appn)=

# Title

Appendices should be provided in `{appendix}` environment. If there is only one appendix,
then please refer to it in text as ... in the {ref}`Appendix <appn>`.

(appA)=

# Title of the first appendix

If there are more than one appendix, then please refer to it
as ... in {numref}`Appendix %s <appA>`, {numref}`Appendix %s <appB>`, etc.

(appB)=

# Title of the second appendix

(appB1)=

## First subsection of {numref}`Appendix %s <appB>`

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard $\LaTeX$ commands for headings in `{appendix}`.
Headings and other objects will be numbered automatically.

```{math}
:label: path
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
```

Sample of cross-reference to formula {eq}`path` in {numref}`Appendix %s <appB1>`.
Note that it is better to refer to {numref}`Appendix %s <appB1>` as opposed to {numref}`Appendix %s <appB>`, because it is easier for the reader to locate the necessary place.
