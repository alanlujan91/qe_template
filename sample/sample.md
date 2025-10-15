---
title: A sample article title
short_title: A sample running head title
exports:
  - format: tex+pdf
    template: .. # Adjust path if needed
    output: sample.pdf
authors:
  - name:
      given: First
      surname: Author
    email: first@somewhere.com
    affiliations: ["aff1", "aff2"]
  - name:
      given: Second
      surname: Author
    email: second@somewhere.com
    affiliations: ["aff3"]
  - name:
      given: Third
      surname: Author
    email: third@somewhere.com
    affiliations: ["aff3"]
affiliations:
  - id: "aff1"
    department: First Department of the First Author
    institution: University
  - id: "aff2"
    department: Second Department of the First Author
    institution: University
  - id: "aff3"
    department: Department of the Second and Third Authors
    institution: University
keywords:
    - First keyword
    - second keyword
    - third keyword
tags:
    - First JEL
    - second JEL
bibliography: main.bib # Corrected to main.bib
abstract: >
  The abstract should summarize the contents of the paper. It should be clear,
  descriptive, self-explanatory and not longer than 150 words. It should also be
  suitable for publication in abstracting services. Please avoid using math formulas
  as much as possible. We recommend 3--8 keywords and up to 3 JEL codes.
acknowledgement: > # Corrected to acknowledgement
  We thank four anonymous referees. The Editor should not be thanked anonymously or by name in this footnote, or elsewhere in the paper. The first author gratefully acknowledges
  financial support from the National Science Foundation through Grant XXX-0000000.
parts:
  appendix: appendix.md # Assuming appendix.md exists and contains appendix content
numbering:
  heading_1: true
  heading_2: true
  heading_3: true
---

(s1)=
# Introduction

This template helps you to create a properly formatted $\LaTeX$ manuscript.
Prepare your paper in the same style as used in this sample .pdf file.
Try to avoid excessive use of italics and bold face; underlining is generally banned (except for exceptional cases). Please do not use any $\LaTeX$ or $\TeX$ commands that affect the layout or formatting of your document (i.e., commands like `\textheight`, `\textwidth`, etc.). Note that the Introduction should be Section {numref}`s1`; it should not immediately follow the abstract without a heading.

# Section headings

Here are some subsections:

## A subsection

Regular text.

### A subsubsection

Regular text.

#### Paragraph heading

If you want to add mini-headings for paragraphs without numbers please use `\paragraph*{}`.

# Text

## Lists

The following is an example of an *itemized* list,
two levels deep.

- This is the first item of an itemized list. Each item in the list is marked with a "tick." The document style determines what kind of tick mark is used.
- This is the second item of the list. It contains another list nested inside of it.
  - This is the first item of an itemized list that is nested within the itemized list.
  - This is the second item of the inner list. $\LaTeX$ allows you to nest lists deeper than you really should.
    This is the rest of the second item of the outer list.
- This is the third item of the list.

The following is an example of an *enumerated* list, two levels deep.

```{raw} latex
\begin{enumerate}[(ii)]
\item
This is the first item of an enumerated list.  Each item
in the list is marked with a ``tick.''  The document
style determines what kind of tick mark is used.
\item
This is the second item of the list.  It contains another
list nested inside of it.
\begin{enumerate}
\item
This is the first item of an enumerated list that
is nested within.
\item
This is the second item of the inner list.  \LaTeX\
allows you to nest lists deeper than you really should.
\end{enumerate}
This is the rest of the second item of the outer list.
\item
This is the third item of the list.
\end{enumerate}
```

Do not use (1), (2), etc.  for items in order to avoid confusion with numbered equations.

## Punctuation

Avoid unnecessary hyphenation; many hyphenated words can be treated as one or two words.
Dashes come in three sizes: a hyphen, an intra-word dash like "$U$-statistics" or "the time-homogeneous model";
a medium dash (also called an "en-dash") for number ranges or between two equal entities like "1--2" or "Cauchy--Schwarz inequality";
and a punctuation dash (also called an "em-dash") in place of a comma, semicolon,
colon or parentheses---like this.

Generating an ellipsis $\ldots$ with the right spacing
around the periods requires using `\ldots`.

*Theoretical Economics* is using longer spaces after periods, please add `\` after periods that are not at the end of a sentence, in order to have regular spaces. For example, if there is an abbreviation (e.g., econ. theory) which is not the end of an article but appears in a middle of a sentence, please code it as `(e.g., econ.\ theory)`.

## Citation

Only include in the reference list entries for which there are text citations,
and make sure all citations are included in the reference list.
Simple author and year cite: {cite:t}`b1`.
Multiple bibliography items cite: {cite:t}`b2; b3; b4; b5`.
Author only cite: {cite:t}`b4`.
Year only cite: {citep}`b4`. Citing bibliography with object {cite}`b1`. Citing within brackets is done with the same commands (e.g., {cite:t}`b2; b3; b4`).

# Fonts

Please use text fonts in text mode, e.g.:

- $\textrm{Roman}$ `\textrm{}`
- $\textit{Italic}$ `\textit{}`
- $\textbf{Bold}$ `\textbf{}`
- $\textsc{Small Caps}$ `\textsc{}`
- $\textsf{Sans serif}$ `\textsf{}`
- $\texttt{Typewriter}$ `\texttt{}`

Please use mathematical fonts in mathematical mode, e.g.:

- $\mathrm{ABCabc123}$ `\mathrm{}`
- $\mathit{ABCabc123}$ `\mathit{}`
- $\mathbf{ABCabc123}$ `\mathbf{}`
- $\boldsymbol{ABCabc123\alpha\beta\gamma}$ `\boldsymbol{}`
- $\mathcal{ABC}$ `\mathcal{}`
- $\mathbb{ABC}$ `\mathbb{}`
- $\mathsf{ABCabc123}$ `\mathsf{}`
- $\mathtt{ABCabc123}$ `\mathtt{}`
- $\mathfrak{ABCabc123}$ `\mathfrak{}`

Note that `\mathcal, \mathbb` belongs to capital letters-only font typefaces.

# Notes

Footnotes[^1]
pose no problems in text.[^2] Please do not add footnotes on math.

[^1]: This is an example of a footnote.
[^2]: Note that footnote number is after punctuation.

# Numbers

A decimal point always should be preceded by a whole number and never should be left "naked." Decimal expressions of numbers less than 1 always should be preceded by a zero (0) to enhance the visibility of the decimal. For example, .3 should be 0.3. This applies to text, tables, and figures.

# Quotations

Text is displayed by indenting it from the left margin. There are short quotations

```{raw} latex
\begin{quote}
This is a short quotation.  It consists of a
single paragraph of text.  There is no paragraph
indentation. It should be coded between \verb|\begin{quote}| and \verb|\end{quote}|.
\end{quote}
```

and longer ones.

```{raw} latex
\begin{quotation}
This is a longer quotation.  It consists of two paragraphs
of text.  The beginning of each paragraph is indicated
by an extra indentation.

This is the second paragraph of the quotation.  It is just
as dull as the first paragraph. It should be coded between \verb|\begin{quotation}| and \verb|\end{quotation}|.
\end{quotation}
```

# Environments

Please use regular counters (Theorem 1) as opposed to counters belonging on sections (Theorem 3.1). Results (Lemmas, Propositions, Theorems, Claims) can be on the same or different counters.

## Examples for *`plain`*-style environments

:::{prf:theorem}
:label: th1
This is the body of Theorem {numref}`th1`.
:::

:::{prf:proof}
This is the body of the proof of the theorem above.
:::

:::{prf:claim}
:label: cl1
This is the body of Claim {numref}`cl1`.
:::

:::{prf:axiom}
:label: ax1
This is the body of Axiom {numref}`ax1`. Axioms should be on a different counter from results (e.g. Theorems, Propositions, Lemmas).
:::

:::{prf:theorem} Title of the Theorem
:label: th2
This is the body of Theorem {numref}`th2`. Theorem {numref}`th2` has additional title.
:::

:::{prf:lemma}
:label: le1
This is the body of Lemma {numref}`le1`. Lemma {numref}`le1` is numbered after
Theorem {numref}`th2` because we used `\verb|[theorem]|` in `\verb|\newtheorem|`.
:::

:::{prf:fact}
This is the body of the fact. Fact is unnumbered because we used the command `\verb|\newtheorem*|`
instead of `\verb|\newtheorem|`.
:::

:::{prf:proof} Proof of Theorem {numref}`th2`
This is the body of the proof of Theorem {numref}`th2`.
:::


## Examples for *`remark`*-style environments

The following environments can be numbered or not; if numbered, they should be on different counters from results.

:::{prf:definition}
:label: de1
This is the body of Definition {numref}`de1`. Definitions should be on a different counter from results (e.g. Theorems, Propositions, Lemmas).
:::

:::{prf:example}
This is the body of the example. Example is unnumbered because we used `\verb|\newtheorem*|`
instead of `\verb|\newtheorem|`.
:::

:::{prf:remark}
This is the body of the remark.
:::


# Equations and the like

Only number equations to which there is a subsequent reference.
See equations below {numref}`ccs`--{numref}`e7`. Please punctuate equations as you would punctuate a sentence, that is add a comma between two equations and add a period if it ends a sentence.

Two equations:

```math
C_{s}  =  K_{M} \frac{\mu/\mu_{x}}{1-\mu/\mu_{x}}
\label{ccs}
```

and

```math
G = \frac{P_{\mathrm{opt}} - P_{\mathrm{ref}}}{P_{\mathrm{ref}}}  100(\%).
```

Equation arrays:

```math
\begin{align}
  \frac{dS}{dt} & = - \sigma X + s_{F} F,\\
  \frac{dX}{dt} & =   \mu    X,\\
  \frac{dP}{dt} & =   \pi    X - k_{h} P,\\
  \frac{dV}{dt} & =   F.
\end{align}
```

One long equation, note that the equation number is on the last line:

```math
\begin{align}
 \mu_{\text{normal}} & = \mu_{x} \frac{C_{s}}{K_{x}C_{x}+C_{s}}  \nonumber\\
                     & = \mu_{\text{normal}} - Y_{x/s}\bigl(1-H(C_{s})\bigr)(m_{s}+\pi /Y_{p/s})\nonumber\\
                     & = \mu_{\text{normal}}/Y_{x/s}+ H(C_{s}) (m_{s}+ \pi /Y_{p/s}).
\label{e7}
\end{align}
```

Note that variables made of more than one letter should use command `\mathit`,
e.g., $\mathit{sov}=550$, where $\mathit{sov}$ is sum of votes. Abbreviations used in subscripts or superscripts should use `\mathrm`,
e.g., $t_{\mathrm{max}}-t_{\mathrm{min}} =10$. Operator names should use `\operatorname`, e.g. $\operatorname{AR}(1)$. Also, note that $\emptyset$ symbol is preferred to $\varnothing$.

# Tables and figures

Cross-references to labeled tables: As you can see in {numref}`sphericcase`
and also in {numref}`parset`.

Sample of cross-reference to figure: {numref}`penG` shows that it is not easy to get something on paper. Note that figures will be in grayscale in the printed version.

```{raw} latex

\begin{table*}
\caption{The spherical case ($I_1=0$, $I_2=0$).}
\label{sphericcase}
\begin{tabular}{@{}lrrrrc@{}@{}}
\hline
Equil. Points
& \multicolumn{1}{c}{$x$}
& \multicolumn{1}{c}{$y$}
& \multicolumn{1}{c}{$z$}
& \multicolumn{1}{c}{$C$}
& S \\
\hline
$L_1$    & $-$2.485252241 & 0.000000000    & 0.017100631    & 8.230711648    & U \\
$L_2$    & 0.000000000    & 0.000000000    & 3.068883732    & 0.000000000    & S \\
$L_3$    & 0.009869059    & 0.000000000    & 4.756386544    & $-$0.000057922 & U \\
$L_4$    & 0.210589855    & 0.000000000    & $-$0.007021459 & 9.440510897    & U \\
$L_5$    & 0.455926604    & 0.000000000    & $-$0.212446624 & 7.586126667    & U \\
$L_6$    & 0.667031314    & 0.000000000    & 0.529879957    & 3.497660052    & U \\
$L_7$    & 2.164386674    & 0.000000000    & $-$0.169308438 & 6.866562449    & U \\
$L_8$    & 0.560414471    & 0.421735658    & $-$0.093667445 & 9.241525367    & U \\
$L_9$    & 0.560414471    & $-$0.421735658 & $-$0.093667445 & 9.241525367    & U \\
$L_{10}$ & 1.472523232    & 1.393484549    & $-$0.083801333 & 6.733436505    & U \\
$L_{11}$ & 1.472523232    & $-$1.393484549 & $-$0.083801333 & 6.733436505    & U \\
\hline
\end{tabular}
\legend{This is how table note should be presented.
Please do not use asterisks or bold face to denote statistical significance.
We encourage authors to report standard errors and coverage sets or confidence intervals.}
\end{table*}

```

```{raw} latex

\begin{table}
\caption{Sample posterior estimates for each model.}
\label{parset}
\begin{tabular}{@{}lcrcrrr@{}@{}}
\hline
& & & &\multicolumn{3}{c}{Quantile} \\
\cline{5-7}
Model
& Parameter
& \multicolumn{1}{c}{Mean}
& Std. Dev.
& \multicolumn{1}{c}{2.5\%}
& \multicolumn{1}{c}{50\%}
& \multicolumn{1}{c@{}}{97.5\%} \\
\hline
{Model 0} & $\beta_0$ & $-$12.29 & 2.29 & $-$18.04 & $-$11.99 & $-$8.56 \\
          & $\beta_1$ & 0.10     & 0.07 & $-$0.05  & 0.10     & 0.26    \\
          & $\beta_2$ & 0.01     & 0.09 & $-$0.22  & 0.02     & 0.16    \\[6pt]
{Model 1} & $\beta_0$ & $-$4.58  & 3.04 & $-$11.00 & $-$4.44  & 1.06    \\
          & $\beta_1$ & 0.79     & 0.21 & 0.38     & 0.78     & 1.20    \\
          & $\beta_2$ & $-$0.28  & 0.10 & $-$0.48  & $-$0.28  & $-$0.07 \\[6pt]
{Model 2} & $\beta_0$ & $-$11.85 & 2.24 & $-$17.34 & $-$11.60 & $-$7.85 \\
          & $\beta_1$ & 0.73     & 0.21 & 0.32     & 0.73     & 1.16    \\
          & $\beta_2$ & $-$0.60  & 0.14 & $-$0.88  & $-$0.60  & $-$0.34 \\
          & $\beta_3$ & 0.22     & 0.17 & $-$0.10  & 0.22     & 0.55    \\
\hline
\end{tabular}
\tablelegend{Sample posterior estimates for each model.}
\end{table}

```


```{figure} figure_sample
:name: penG
The dotted lines show the values of $u(x)$ for $x$ in the discrete support of $F$. The solid lines show $u_\textrm{conv}(x)$.
```

