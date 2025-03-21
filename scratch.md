template.yml

jtex: v1
title: Quantitative Economics Template (QE Sample - MystMD Standard)
description: Template using MystMD standard frontmatter for QE sample reproduction
version: 1.0.0
license: MIT
source: https://example.com/author-guidelines/latex-submission
thumbnail: ./thumbnail.png
authors:
  - name: Alan Lujan # Example author info - you can adjust
    website: https://example.com # Example website
    affiliations:
      - Unofficial # Example affiliation tag
tags:
  - paper
parts:
  - id: abstract
    required: true
    description: Abstract of the paper
  - id: acknowledgement # Corrected to "acknowledgement" to match sample.md and template.tex
    required: false
    description: Support/acknowledgement information
  - id: appendix
    required: false
    description: Appendix content (optional)
doc: # Correct doc definition - list of property objects
  - id: title
    required: true
    description: Title of the paper
  - id: short_title
    required: true
    description: Running head title
  - id: bibliography # For bibliography file path
    required: false # Bibliography is optional
    description: Bibliography file (BibTeX .bib file)
  - id: keywords
    required: false
    description: Keywords for the paper
  - id: tags
    required: false
    description: JEL codes/tags for the paper
  - id: authors # Using standard "authors" key - list of author objects
    required: true
    description: List of author objects
  - id: affiliations # Using standard "affiliations" key - list of affiliation objects
    required: true
    description: List of affiliation objects
  - id: math # For math macro definitions
    required: false
    description: Math macro definitions
options:
  - type: boolean
    id: draft
    description: Mark the document as draft
    default: false
files:
  - template.tex
  - econsocart.cfg
  - econsocart.cls
  - qe.bst
packages:
  - amsmath
  - amssymb
  - amsthm
  - bm
  - etoolbox
  - float
  - fontenc
  - graphicx
  - hyperref
  - textcomp
  - times
  - url
myst: v1

---

template.tex

% Template for the submission to:
%   Econometrica   [ecta]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% In this template, the places where you   %%
%% need to fill in your information are     %%
%% indicated by '???'.                      %%
%%                                          %%
%% Please do not use \input{...} to include %%
%% other tex files. Submit your LaTeX       %%
%% manuscript as one .tex document.         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% use option [draft] for initial submission
%            [final] for the prepublication
[# if options.draft #]
\documentclass[qe,nameyear,draft]{econsocart}
[# else #]
\documentclass[qe,nameyear,final]{econsocart}
[# endif #]
%
%\usepackage{}
\RequirePackage[colorlinks,citecolor=blue,linkcolor=blue,urlcolor=blue,pagebackref]{hyperref}

\startlocaldefs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please put your definitions here:        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[-IMPORTS-]




\endlocaldefs

\begin{document}

\begin{frontmatter}

\title{[-doc.title-]}
\runtitle{[-doc.short_title-]}

\begin{aug}
% use \particle for den|der|de|van|von (only lc!)
% [id=?,addressref=?,corref]{\fnms{}~\snm{}\ead[label=e?]{}\thanksref{}}
%
%% e-mail is mandatory for each author
%
%%% initials in fnms (if any) with spaces
%
[# for author in doc.authors #]
\author[id=au{{ loop.index }},addressref={
    [# for aff_id in author.affiliations #][-aff_id-][# if not loop.last #],[# endif #][# endfor #]
    }]{\fnms{[-author.name|trim-]}\ead[label=e{{ loop.index }}]{[-author.email-]}}
[#- endfor -#]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Addresses                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[# for affiliation in doc.affiliations #]
\address[id=[-affiliation.id-]]{%
\orgdiv{[-affiliation.department|default('')|trim-]},\\[\smallskipamount]
\orgname{[-affiliation.institution|default('')|trim-]}}
[# endfor #]
\end{aug}

%% Put support info here. Reminder: do not thank the handling coeditor anonymously or by name
[# if parts.acknowledgement #]
\support{[-parts.acknowledgement-]}
[# endif #]
%
\coeditor{\fnms{[Name} \snm{Surname}; will be inserted later]}

\begin{abstract}
[-parts.abstract-]
\end{abstract}

\begin{keyword}
[# if doc.keywords #]
[# for kw in doc.keywords #]
\kwd{[-kw|trim-]}
[# endfor #]
[# endif #]
\end{keyword}

\begin{keyword}[class=JEL] %% alphabetical order
[# if doc.tags #]
[# for code in doc.tags #]
\kwd{[-code|trim-]}
[# endfor #]
[# endif #]
\end{keyword}

\end{frontmatter}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Main text entry area:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[-CONTENT-]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example with single Appendix:  Conditional Inclusion %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[# if parts.appendix #]
\begin{appendix}
\section*{Title}\label{appn} %% if no title is needed, leave empty \section*{}.
[-parts.appendix-]
\end{appendix}
[# endif #]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography:  BibTeX Version          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[# if doc.bibliography #]
\bibliographystyle{qe} % Style BST file
\bibliography{[-doc.bibliography-]}  % Bibliography file (usually '*.bib')
[# else #]
%% NOTE: User has not specified a bibliography file in frontmatter.
%% If you want to use BibTeX, please specify 'bibliography: <your_bib_file.bib>'
%% in your document's frontmatter.
[# endif #]

\end{document}

---

sample.md

---
title: A sample article title
short_title: A sample running head title
exports:
  - format: tex+pdf
    template: .. # Adjust path if needed
    output: sample.pdf
authors:
  - name: First Author
    email: first@somewhere.com
    affiliations: ["aff1", "aff2"]
  - name: Second Author
    email: second@somewhere.com
    affiliations: ["aff3"]
  - name: Third Author
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
math:
  '\LaTeXe' : '\LaTeX2\varepsilon'
numbering:
  heading_1: true
  heading_2: true
  heading_3: true
---

(s1)=
# Introduction

This template helps you to create a properly formatted $\LaTeXe$ manuscript.
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

(appn)=
# Appendix

(appA)=
## Title of the first appendix

If there are more than one appendix, then please refer to it
as ... in Appendix Section {numref}`appA`, Appendix Section {numref}`appB`, etc.

(appB)=
## Title of the second appendix

(appB1)=
### First subsection of Appendix Section {numref}`appB`

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard $\LaTeX$ commands for headings in `{appendix}`.
Headings and other objects will be numbered automatically.

```math
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
\label{path}
```

Sample of cross-reference to formula {numref}`path` in Appendix Section {numref}`appB1`.
Note that it is better to refer to Appendix Section {numref}`appB1` as opposed to Appendix Section {numref}`appB`, because it is easier for the reader to locate the necessary place.

---

appendix.md

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
then please refer to it in text as ... in the {numref}`appn`.

(appA)=
# Title of the first appendix 

If there are more than one appendix, then please refer to it
as ... in Appendix {numref}`appA`, Appendix {numref}`appB`, etc.

(appB)=
# Title of the second appendix 

(appB1)=
## First subsection of Appendix {numref}`appB`

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard $\LaTeX$ commands for headings in `{appendix}`.
Headings and other objects will be numbered automatically.

$$
\begin{equation}
\label{path}
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
\end{equation}
$$

Sample of cross-reference to formula {numref}`path` in Appendix {numref}`appB1`.
Note that it is better to refer to Appendix {numref}`appB1` as opposed to Appendix {numref}`appB`, because it is easier for the reader to locate the necessary place. 


---

sample.tex

% Created with jtex v.1.0.20
% Template for the submission to:
%   Econometrica   [ecta]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% In this template, the places where you   %%
%% need to fill in your information are     %%
%% indicated by '???'.                      %%
%%                                          %%
%% Please do not use \input{...} to include %%
%% other tex files. Submit your LaTeX       %%
%% manuscript as one .tex document.         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% use option [draft] for initial submission
%            [final] for the prepublication
\documentclass[qe,nameyear,final]{econsocart}
%
%\usepackage{}
\RequirePackage[colorlinks,citecolor=blue,linkcolor=blue,urlcolor=blue,pagebackref]{hyperref}

\startlocaldefs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please put your definitions here:        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  imports  %%%%%%%%%%%%%%%%%%%
\usepackage{natbib}
%%%%%%%%%%%%%%%%%  math commands  %%%%%%%%%%%%%%%%
\newcommand{\LaTeXe}{\LaTeX2\varepsilon}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  theorem  %%%%%%%%%%%%%%%%%%%
\newtheorem{theorem}{Theorem}[section]
\newtheorem{corollary}{Corollary}[theorem]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}{Proposition}[section]
\newtheorem{definition}{Definition}[section]
\newtheorem{example}{Example}[section]
\newtheorem{remark}{Remark}[section]
\newtheorem{axiom}{Axiom}[section]
\newtheorem{conjecture}{Conjecture}[section]
\newtheorem{observation}{Observation}[section]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







\endlocaldefs

\begin{document}

\begin{frontmatter}

\title{A sample article title}
\runtitle{A sample running head title}

\begin{aug}
% use \particle for den|der|de|van|von (only lc!)
% [id=?,addressref=?,corref]{\fnms{}~\snm{}\ead[label=e?]{}\thanksref{}}
%
%% e-mail is mandatory for each author
%
%%% initials in fnms (if any) with spaces
%
\author[id=au{{ loop.index }},addressref={
    [object Object],[object Object]    }]{\fnms{First Author}\ead[label=e{{ loop.index }}]{first@somewhere.com}}\author[id=au{{ loop.index }},addressref={
    [object Object]    }]{\fnms{Second Author}\ead[label=e{{ loop.index }}]{second@somewhere.com}}\author[id=au{{ loop.index }},addressref={
    [object Object]    }]{\fnms{Third Author}\ead[label=e{{ loop.index }}]{third@somewhere.com}}%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Addresses                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\address[id=aff1]{%
\orgdiv{First Department of the First Author},\\[\smallskipamount]
\orgname{}}
\address[id=aff2]{%
\orgdiv{Second Department of the First Author},\\[\smallskipamount]
\orgname{}}
\address[id=aff3]{%
\orgdiv{Department of the Second and Third Authors},\\[\smallskipamount]
\orgname{}}
\end{aug}

%% Put support info here. Reminder: do not thank the handling coeditor anonymously or by name
\support{We thank four anonymous referees. The Editor should not be thanked anonymously or by name in this footnote, or elsewhere in the paper. The first author gratefully acknowledges financial support from the National Science Foundation through Grant XXX-0000000.}
%
\coeditor{\fnms{[Name} \snm{Surname}; will be inserted later]}

\begin{abstract}
The abstract should summarize the contents of the paper. It should be clear, descriptive, self-explanatory and not longer than 150 words. It should also be suitable for publication in abstracting services. Please avoid using math formulas as much as possible. We recommend 3--8 keywords and up to 3 JEL codes.
\end{abstract}

\begin{keyword}
\kwd{First keyword}
\kwd{second keyword}
\kwd{third keyword}
\end{keyword}

\begin{keyword}[class=JEL] %% alphabetical order
\kwd{First JEL}
\kwd{second JEL}
\end{keyword}

\end{frontmatter}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Main text entry area:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\section{Introduction}\label{s1}

This template helps you to create a properly formatted $\LaTeXe$ manuscript.
Prepare your paper in the same style as used in this sample .pdf file.
Try to avoid excessive use of italics and bold face; underlining is generally banned (except for exceptional cases). Please do not use any $\LaTeX$ or $\TeX$ commands that affect the layout or formatting of your document (i.e., commands like \texttt{{\textbackslash}textheight}, \texttt{{\textbackslash}textwidth}, etc.). Note that the Introduction should be Section Introduction; it should not immediately follow the abstract without a heading.

\section{Section headings}

Here are some subsections:

\subsection{A subsection}

Regular text.

\subsubsection{A subsubsection}

Regular text.

\paragraph{Paragraph heading}

If you want to add mini-headings for paragraphs without numbers please use \texttt{{\textbackslash}paragraph*\{\}}.

\section{Text}

\subsection{Lists}

The following is an example of an \textit{itemized} list,
two levels deep.

\begin{itemize}
\item This is the first item of an itemized list. Each item in the list is marked with a ``tick.'' The document style determines what kind of tick mark is used.
\item This is the second item of the list. It contains another list nested inside of it.\begin{itemize}
\item This is the first item of an itemized list that is nested within the itemized list.
\item This is the second item of the inner list. $\LaTeX$ allows you to nest lists deeper than you really should.
This is the rest of the second item of the outer list.
\end{itemize}


\item This is the third item of the list.
\end{itemize}

The following is an example of an \textit{enumerated} list, two levels deep.


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
Do not use (1), (2), etc.  for items in order to avoid confusion with numbered equations.

\subsection{Punctuation}

Avoid unnecessary hyphenation; many hyphenated words can be treated as one or two words.
Dashes come in three sizes: a hyphen, an intra-word dash like ``$U$-statistics'' or ``the time-homogeneous model'';
a medium dash (also called an ``en-dash'') for number ranges or between two equal entities like ``1--2'' or ``Cauchy--Schwarz inequality'';
and a punctuation dash (also called an ``em-dash'') in place of a comma, semicolon,
colon or parentheses---like this.

Generating an ellipsis $\ldots$ with the right spacing
around the periods requires using \texttt{{\textbackslash}ldots}.

\textit{Theoretical Economics} is using longer spaces after periods, please add \texttt{{\textbackslash}} after periods that are not at the end of a sentence, in order to have regular spaces. For example, if there is an abbreviation (e.g., econ. theory) which is not the end of an article but appears in a middle of a sentence, please code it as \texttt{(e.g., econ.{\textbackslash}~theory)}.

\subsection{Citation}

Only include in the reference list entries for which there are text citations,
and make sure all citations are included in the reference list.
Simple author and year cite: \citet{b1}.
Multiple bibliography items cite: \citet{b2, b3, b4, b5}.
Author only cite: \citet{b4}.
Year only cite: . Citing bibliography with object \cite{b1}. Citing within brackets is done with the same commands (e.g., \citet{b2, b3, b4}).

\section{Fonts}

Please use text fonts in text mode, e.g.:

\begin{itemize}
\item $\textrm{Roman}$ \texttt{{\textbackslash}textrm\{\}}
\item $\textit{Italic}$ \texttt{{\textbackslash}textit\{\}}
\item $\textbf{Bold}$ \texttt{{\textbackslash}textbf\{\}}
\item $\textsc{Small Caps}$ \texttt{{\textbackslash}textsc\{\}}
\item $\textsf{Sans serif}$ \texttt{{\textbackslash}textsf\{\}}
\item $\texttt{Typewriter}$ \texttt{{\textbackslash}texttt\{\}}
\end{itemize}

Please use mathematical fonts in mathematical mode, e.g.:

\begin{itemize}
\item $\mathrm{ABCabc123}$ \texttt{{\textbackslash}mathrm\{\}}
\item $\mathit{ABCabc123}$ \texttt{{\textbackslash}mathit\{\}}
\item $\mathbf{ABCabc123}$ \texttt{{\textbackslash}mathbf\{\}}
\item $\boldsymbol{ABCabc123\alpha\beta\gamma}$ \texttt{{\textbackslash}boldsymbol\{\}}
\item $\mathcal{ABC}$ \texttt{{\textbackslash}mathcal\{\}}
\item $\mathbb{ABC}$ \texttt{{\textbackslash}mathbb\{\}}
\item $\mathsf{ABCabc123}$ \texttt{{\textbackslash}mathsf\{\}}
\item $\mathtt{ABCabc123}$ \texttt{{\textbackslash}mathtt\{\}}
\item $\mathfrak{ABCabc123}$ \texttt{{\textbackslash}mathfrak\{\}}
\end{itemize}

Note that \texttt{{\textbackslash}mathcal, {\textbackslash}mathbb} belongs to capital letters-only font typefaces.

\section{Notes}

Footnotes\footnote{This is an example of a footnote.}
pose no problems in text.\footnote{Note that footnote number is after punctuation.} Please do not add footnotes on math.

\section{Numbers}

A decimal point always should be preceded by a whole number and never should be left ``naked.'' Decimal expressions of numbers less than 1 always should be preceded by a zero (0) to enhance the visibility of the decimal. For example, .3 should be 0.3. This applies to text, tables, and figures.

\section{Quotations}

Text is displayed by indenting it from the left margin. There are short quotations


\begin{quote}
This is a short quotation.  It consists of a
single paragraph of text.  There is no paragraph
indentation. It should be coded between \verb|\begin{quote}| and \verb|\end{quote}|.
\end{quote}
and longer ones.


\begin{quotation}
This is a longer quotation.  It consists of two paragraphs
of text.  The beginning of each paragraph is indicated
by an extra indentation.

This is the second paragraph of the quotation.  It is just
as dull as the first paragraph. It should be coded between \verb|\begin{quotation}| and \verb|\end{quotation}|.
\end{quotation}
\section{Environments}

Please use regular counters (Theorem 1) as opposed to counters belonging on sections (Theorem 3.1). Results (Lemmas, Propositions, Theorems, Claims) can be on the same or different counters.

\subsection{Examples for \textit{\texttt{plain}}-style environments}

\begin{theorem}\label{th1}This is the body of Theorem Theorem~\ref{th1}.

\end{theorem}\begin{proof}This is the body of the proof of the theorem above.

\end{proof}

\begin{axiom}\label{ax1}This is the body of Axiom Axiom~\ref{ax1}. Axioms should be on a different counter from results (e.g. Theorems, Propositions, Lemmas).

\end{axiom}\begin{theorem}[Title of the Theorem]\label{th2}This is the body of Theorem Theorem~\ref{th2}. Theorem Theorem~\ref{th2} has additional title.

\end{theorem}\begin{lemma}\label{le1}This is the body of Lemma Lemma~\ref{le1}. Lemma Lemma~\ref{le1} is numbered after
Theorem Theorem~\ref{th2} because we used \texttt{{\textbackslash}verb|[theorem]|} in \texttt{{\textbackslash}verb|{\textbackslash}newtheorem|}.

\end{lemma}

\begin{proof}[Proof of Theorem ]\textbf{Theorem~\ref{th2}}\\
This is the body of the proof of Theorem Theorem~\ref{th2}.

\end{proof}\subsection{Examples for \textit{\texttt{remark}}-style environments}

The following environments can be numbered or not; if numbered, they should be on different counters from results.

\begin{definition}\label{de1}This is the body of Definition Definition~\ref{de1}. Definitions should be on a different counter from results (e.g. Theorems, Propositions, Lemmas).

\end{definition}\begin{example}This is the body of the example. Example is unnumbered because we used \texttt{{\textbackslash}verb|{\textbackslash}newtheorem*|}
instead of \texttt{{\textbackslash}verb|{\textbackslash}newtheorem|}.

\end{example}\begin{remark}This is the body of the remark.

\end{remark}\section{Equations and the like}

Only number equations to which there is a subsequent reference.
See equations below (\ref{ccs})--(\ref{e7}). Please punctuate equations as you would punctuate a sentence, that is add a comma between two equations and add a period if it ends a sentence.

Two equations:

\begin{equation}
\label{ccs}
C_{s}  =  K_{M} \frac{\mu/\mu_{x}}{1-\mu/\mu_{x}}
\end{equation}

and

\begin{equation}
G = \frac{P_{\mathrm{opt}} - P_{\mathrm{ref}}}{P_{\mathrm{ref}}}  100(\%).
\end{equation}

Equation arrays:

\begin{align}
  \frac{dS}{dt} & = - \sigma X + s_{F} F,\\
  \frac{dX}{dt} & =   \mu    X,\\
  \frac{dP}{dt} & =   \pi    X - k_{h} P,\\
  \frac{dV}{dt} & =   F.
\end{align}

One long equation, note that the equation number is on the last line:

\begin{align}
 \mu_{\text{normal}} & = \mu_{x} \frac{C_{s}}{K_{x}C_{x}+C_{s}}  \nonumber\\
                     & = \mu_{\text{normal}} - Y_{x/s}\bigl(1-H(C_{s})\bigr)(m_{s}+\pi /Y_{p/s})\nonumber\\
                     & = \mu_{\text{normal}}/Y_{x/s}+ H(C_{s}) (m_{s}+ \pi /Y_{p/s}).

\end{align}

Note that variables made of more than one letter should use command \texttt{{\textbackslash}mathit},
e.g., $\mathit{sov}=550$, where $\mathit{sov}$ is sum of votes. Abbreviations used in subscripts or superscripts should use \texttt{{\textbackslash}mathrm},
e.g., $t_{\mathrm{max}} -t_{\mathrm{min}} =10$. Operator names should use \texttt{{\textbackslash}operatorname}, e.g. $\operatorname{AR}(1)$. Also, note that $\emptyset$ symbol is preferred to $\varnothing$.

\section{Tables and figures}

Cross-references to labeled tables: As you can see in Table~\ref{sphericcase}
and also in Table~\ref{parset}.

Sample of cross-reference to figure: Figure~\ref{penG} shows that it is not easy to get something on paper. Note that figures will be in grayscale in the printed version.


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
\begin{figure}[!htbp]
\centering
\includegraphics[width=0.7\linewidth]{files/figure_sample-9969f7ce83df78ffdf8e06d9407d8e40.pdf}
\caption[]{The dotted lines show the values of $u(x)$ for $x$ in the discrete support of $F$. The solid lines show $u_\textrm{conv}(x)$.}
\label{penG}
\end{figure}

\section{Appendix}\label{appn}

\subsection{Title of the first appendix}\label{appA}

If there are more than one appendix, then please refer to it
as ... in Appendix Section Title~of~the~first~appendix, Appendix Section Title~of~the~second~appendix, etc.

\subsection{Title of the second appendix}\label{appB}

\subsubsection{First subsection of Appendix Section Title~of~the~second~appendix}\label{appB1}

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard $\LaTeX$ commands for headings in \texttt{\{appendix\}}.
Headings and other objects will be numbered automatically.

\begin{equation}
\label{path}
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
\end{equation}

Sample of cross-reference to formula (\ref{path}) in Appendix Section First~subsection~of~Appendix~Section~Title~of~the~second~appendix.
Note that it is better to refer to Appendix Section First~subsection~of~Appendix~Section~Title~of~the~second~appendix as opposed to Appendix Section Title~of~the~second~appendix, because it is easier for the reader to locate the necessary place.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example with single Appendix:  Conditional Inclusion %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{appendix}
\section*{Title}\label{appn} %% if no title is needed, leave empty \section*{}.
\subsection{Title}\label{appn}

Appendices should be provided in \texttt{\{appendix\}} environment. If there is only one appendix,
then please refer to it in text as ... in the Appendix.

\subsection{Title of the first appendix}\label{appA}

If there are more than one appendix, then please refer to it
as ... in Appendix Title~of~the~first~appendix, Appendix Title~of~the~second~appendix, etc.

\subsection{Title of the second appendix}\label{appB}

\subsubsection{First subsection of Appendix Title~of~the~second~appendix}\label{appB1}

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard $\LaTeX$ commands for headings in \texttt{\{appendix\}}.
Headings and other objects will be numbered automatically.

\begin{equation}
\label{path}
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
\end{equation}

Sample of cross-reference to formula (\ref{path}) in Appendix First~subsection~of~Appendix~Section~Title~of~the~second~appendix.
Note that it is better to refer to Appendix First~subsection~of~Appendix~Section~Title~of~the~second~appendix as opposed to Appendix Title~of~the~second~appendix, because it is easier for the reader to locate the necessary place.
\end{appendix}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography:  BibTeX Version          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\bibliographystyle{qe} % Style BST file
\bibliography{main.bib}  % Bibliography file (usually '*.bib')

\end{document}

---

qe_sample.tex

% use option [draft] for initial submission
%            [final] for the prepublication
\documentclass[qe,nameyear,draft]{econsocart}
%
%\usepackage{}
\RequirePackage[colorlinks,citecolor=blue,linkcolor=blue,urlcolor=blue,pagebackref]{hyperref}

\startlocaldefs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                          %%
%% Uncomment next line to change            %%
%% the type of equation numbering           %%
%%                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\numberwithin{equation}{section}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                          %%
%% For Assumption, Axiom, Claim, Corollary, %%
%% Lemma, Theorem, Proposition, Hypothezis, %%
%% Fact                                     %%
%% use \theoremstyle{plain}                 %%
%%                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\theoremstyle{plain}
\newtheorem{axiom}{Axiom}
\newtheorem{theorem}{Theorem}
\newtheorem{claim}{Claim}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem*{fact}{Fact}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                          %%
%% For Definition, Example, Remark,         %%
%% Notation, Property                       %%
%% use \theoremstyle{remark}                %%
%%                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\theoremstyle{remark}
\newtheorem{definition}{Definition}
\newtheorem*{example}{Example}
\newtheorem{remark}{Remark}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please put your definitions here:        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\endlocaldefs

\begin{document}

\begin{frontmatter}

\title{A sample article title}
\runtitle{A sample running head title}

\begin{aug}
% use \particle for den|der|de|van|von (only lc!)
% [id=?,addressref=?,corref]{\fnms{}~\snm{}\ead[label=e?]{}\thanksref{}}
%
%% e-mail is mandatory for each author
%
%%% initials in fnms (if any) with spaces
%
\author[id=au1,addressref={add1,add11}]{\fnms{First}~\snm{Author}\ead[label=e1]{first@somewhere.com}}
\author[id=au2,addressref={add2}]{\fnms{Second}~\snm{Author}\ead[label=e2]{second@somewhere.com}}
\author[id=au3,addressref={add2}]{\fnms{Third}~\snm{Author}\ead[label=e3]{third@somewhere.com}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Addresses                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\address[id=add1]{%
\orgdiv{First Department of the First Author},
\orgname{University}}

\address[id=add11]{%
\orgdiv{Second Department of the First Author},
\orgname{University}}

\address[id=add2]{%
\orgdiv{Department of the Second and Third Authors},
\orgname{University}}
\end{aug}

%% Put support info here. Reminder: do not thank the handling coeditor anonymously or by name
\support{We thank four anonymous referees. The Editor should not be thanked anonymously or by name in this footnote, or elsewhere in the paper. The first author gratefully acknowledges
financial support from the National Science Foundation through Grant XXX-0000000.}
%
\coeditor{\fnm{[Name} \snm{Surname}; will be inserted later]}

\begin{abstract}
The abstract should summarize the contents of the paper. It should be clear,
descriptive, self-explanatory and not longer than 150 words. It should also be
suitable for publication in abstracting services. Please avoid using math formulas
as much as possible. We recommend 3--8 keywords and up to 3 JEL codes.
\end{abstract}


\begin{keyword}
\kwd{First keyword}
\kwd{second keyword}
\kwd{third keyword}
\end{keyword}

\begin{keyword}[class=JEL] %% alphabetical order
\kwd{First JEL}
\kwd{second JEL}
\end{keyword}

\end{frontmatter}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Main text entry area:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\section{Introduction}\label{s1}

This template helps you to create a properly formatted \LaTeXe\ manuscript.
Prepare your paper in the same style as used in this sample .pdf file.
Try to avoid excessive use of italics and bold face; underlining is generally banned (except for exceptional cases). Please do not use any \LaTeXe\ or \TeX\ commands that affect the layout or formatting of your document (i.e., commands like \verb|\textheight|, \verb|\textwidth|, etc.). Note that the Introduction should be Section~\ref{s1} it should not imediately follow the abstract without a heading.

\section{Section headings}
Here are some subsections:
\subsection{A subsection}
Regular text.
\subsubsection{A subsubsection}
Regular text.

\paragraph*{Paragraph heading} If you want to add mini-headings for paragraphs without numbers please use \verb|\paragraph*{}|.

\section{Text}

\subsection{Lists}

The following is an example of an \emph{itemized} list,
two levels deep.
\begin{itemize}
\item
This is the first item of an itemized list.  Each item
in the list is marked with a ``tick.''  The document
style determines what kind of tick mark is used.
\item
This is the second item of the list.  It contains another
list nested inside of it.
\begin{itemize}
\item This is the first item of an itemized list that
is nested within the itemized list.
\item This is the second item of the inner list.  \LaTeX\
allows you to nest lists deeper than you really should.
\end{itemize}
This is the rest of the second item of the outer list.
\item
This is the third item of the list.
\end{itemize}

The following is an example of an \emph{enumerated} list, two levels deep.
\begin{enumerate}[(ii)]
\item[(i)]
This is the first item of an enumerated list.  Each item
in the list is marked with a ``tick.''  The document
style determines what kind of tick mark is used.
\item[(ii)]
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
\item [(iii)]
This is the third item of the list.
\end{enumerate}

Do not use (1), (2), etc.\ for items in order to avoid confusion with numbered equations.

\subsection{Punctuation}
Avoid unnecessary hyphenation; many hyphenated words can be treated as one or two words.
Dashes come in three sizes: a hyphen, an intra-word dash like ``$U$-statistics'' or ``the time-homogeneous model'';
a medium dash (also called an ``en-dash'') for number ranges or between two equal entities like ``1--2'' or ``Cauchy--Schwarz inequality'';
and a punctuation dash (also called an ``em-dash'') in place of a comma, semicolon,
colon or parentheses---like this.

Generating an ellipsis \ldots\ with the right spacing
around the periods requires using \verb|\ldots|.

\textit{Theoretical Economics} is using longer spaces after periods, please add \verb|\| after periods that are not at the end of a sentence, in order to have regular spaces. For example, if there is an abbreviation (e.g., econ. theory) which is not the end of an article but appears in a middle of a sentence, please code it as \verb|(e.g., econ.\ theory)|. 

\subsection{Citation}
Only include in the reference list entries for which there are text citations,
and make sure all citations are included in the reference list.
Simple author and year cite: \citet{b1}. 
Multiple bibliography items cite: \citet{b2,b3,b4,b5}.
Author only cite: \citeauthor{b4}.
Year only cite: (\citeyear{b4}). Citing bibliography with object \citet[Theorem 1]{b1}. Citing within brackets is done with the same commands (e.g., \citet{b2,b3,b4}).

\section{Fonts}
Please use text fonts in text mode, e.g.:
\begin{itemize}
\item[]\textrm{Roman} \verb|\textrm{}|
\item[]\textit{Italic} \verb|\textit{}|
\item[]\textbf{Bold} \verb|\textbf{}|
\item[]\textsc{Small Caps} \verb|\textsc{}|
\item[]\textsf{Sans serif} \verb|\textsf{}|
\item[]\texttt{Typewriter} \verb|\texttt{}|
\end{itemize}
Please use mathematical fonts in mathematical mode, e.g.:
\begin{itemize}
\item[] $\mathrm{ABCabc123}$ \verb|\mathrm{}|
\item[] $\mathit{ABCabc123}$ \verb|\mathit{}|
\item[] $\mathbf{ABCabc123}$ \verb|\mathbf{}|
\item[] $\boldsymbol{ABCabc123\alpha\beta\gamma}$ \verb|\boldsymbol{}|
\item[] $\mathcal{ABC}$ \verb|\mathcal{}|
\item[] $\mathbb{ABC}$ \verb|\mathbb{}|
\item[] $\mathsf{ABCabc123}$ \verb|\mathsf{}| 
\item[] $\mathtt{ABCabc123}$ \verb|\mathtt{}|
\item[] $\mathfrak{ABCabc123}$ \verb|\mathfrak{}|
\end{itemize}
Note that \verb|\mathcal, \mathbb| belongs to capital letters-only font typefaces.

\section{Notes}
Footnotes\footnote{This is an example of a footnote.}
pose no problems in text.\footnote{Note that footnote number is after punctuation.} Please do not add footnotes on math. 

\section{Numbers}
A decimal point always should be preceded by a whole number and never should be left ``naked.'' Decimal expressions of numbers less than 1 always should be preceded by a zero (0) to enhance the visibility of the decimal. For example, .3 should be 0.3.   This applies to text, tables, and figures.


\section{Quotations}

Text is displayed by indenting it from the left margin. There are short quotations
\begin{quote}
This is a short quotation.  It consists of a
single paragraph of text.  There is no paragraph
indentation. It should be coded between \verb|\begin{quote}| and \verb|\end{quote}|.
\end{quote}
and longer ones.
\begin{quotation}
This is a longer quotation.  It consists of two paragraphs
of text.  The beginning of each paragraph is indicated
by an extra indentation.

This is the second paragraph of the quotation.  It is just
as dull as the first paragraph. It should be coded between \verb|\begin{quotation}| and \verb|\end{quotation}|.
\end{quotation}

\section{Environments}

Please use regular counters (Theorem 1) as opposed to counters belonging on sections (Theorem 3.1). Results (Lemmas, Propositions, Theorems, Claims) can be on the same or different counters.

\subsection{Examples for \emph{\texttt{plain}}-style environments}

\begin{theorem}\label{th1}
This is the body of Theorem \ref{th1}.
\end{theorem}


\begin{proof}
This is the body of the proof of the theorem above.
\end{proof}

\begin{claim}\label{cl1}
This is the body of Claim \ref{cl1}. 
\end{claim}



\begin{axiom}\label{ax1}
This is the body of Axiom \ref{ax1}. Axioms should be on a different counter from results (e.g. Theorems, Propositions, Lemmas).
\end{axiom}

\begin{theorem}[Title of the Theorem]\label{th2}
This is the body of Theorem \ref{th2}. Theorem~\ref{th2} has additional title.
\end{theorem}

\begin{lemma}\label{le1}
This is the body of Lemma \ref{le1}. Lemma \ref{le1} is numbered after
Theorem \ref{th2} because we used \verb|[theorem]| in \verb|\newtheorem|.
\end{lemma}

\begin{fact}
This is the body of the fact. Fact is unnumbered because we used the command \verb|\newtheorem*|
instead of \verb|\newtheorem|.
\end{fact}

\begin{proof}[Proof of Theorem \ref{th2}]
This is the body of the proof of Theorem \ref{th2}.
\end{proof}


\subsection{Examples for \emph{\texttt{remark}}-style environments}

The following environments can be numbered or not; if numbered, they should be on different counters from results.

\begin{definition}\label{de1}
This is the body of Definition \ref{de1}. Definitions should be on a different counter from results (e.g. Theorems, Propositions, Lemmas).
\end{definition}

\begin{example}
This is the body of the example. Example is unnumbered because we used \verb|\newtheorem*|
instead of \verb|\newtheorem|.
\end{example}

\begin{remark}
This is the body of the remark. 
\end{remark}

\section{Equations and the like}
Only number equations to which there is a subsequent reference.
See equations below (\ref{ccs})--(\ref{e7}). Please punctuate equations as you would punctuate a sentence, that is add a comma between two equations and add a period if it ends a sentence.

Two equations:
\begin{equation}
    C_{s}  =  K_{M} \frac{\mu/\mu_{x}}{1-\mu/\mu_{x}} \label{ccs}
\end{equation}
and
\begin{equation}
    G = \frac{P_{\mathrm{opt}} - P_{\mathrm{ref}}}{P_{\mathrm{ref}}}  100(\%).
\end{equation}
Equation arrays:
\begin{eqnarray}
  \frac{dS}{dt} & = & - \sigma X + s_{F} F,\\
  \frac{dX}{dt} & = &   \mu    X,\\
  \frac{dP}{dt} & = &   \pi    X - k_{h} P,\\
  \frac{dV}{dt} & = &   F.
\end{eqnarray}
One long equation, note that the equation number is on the last line:
\begin{eqnarray}
 \mu_{\text{normal}} & = & \mu_{x} \frac{C_{s}}{K_{x}C_{x}+C_{s}}  \nonumber\\
                     & = & \mu_{\text{normal}} - Y_{x/s}\bigl(1-H(C_{s})\bigr)(m_{s}+\pi /Y_{p/s})\nonumber\\
                     & = & \mu_{\text{normal}}/Y_{x/s}+ H(C_{s}) (m_{s}+ \pi /Y_{p/s}).\label{e7}
\end{eqnarray}
Note that variables made of more than one letter should use command \verb|\mathit|,
e.g., $\mathit{sov}=550$, where $\mathit{sov}$ is sum of votes. Abbreviations used in subscripts or superscripts should use \verb|\mathrm|,
e.g., $t_{\mathrm{max}}-t_{\mathrm{min}} =10$. Operator names should use \verb|\operatorname|, e.g. $\operatorname{AR}(1)$. Also, note that $\emptyset$ symbol is preferred to $\varnothing$.

\section{Tables and figures}
Cross-references to labeled tables: As you can see in Table~\ref{sphericcase}
and also in Table~\ref{parset}.

Sample of cross-reference to figure: Figure~\ref{penG} shows that it is not easy to get something on paper. Note that figures will be in grayscale in the printed version.

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

\begin{table}
\caption{Sample posterior estimates for each model.}
\label{parset}
%
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
%
\end{table}

\begin{figure}
\includegraphics{figure_sample}
\caption{The dotted lines show the values of $u(x)$ for $x$ in the discrete support of $F$. The solid lines show $u_\textrm{conv}(x)$.}
\label{penG}
\end{figure}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example with single Appendix:            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{appendix}
\section*{Title}\label{appn} %% if no title is needed, leave empty \section*{}.
Appendices should be provided in \verb|{appendix}| environment. If there is only one appendix,
then please refer to it in text as \ldots\ in the \hyperref[appn]{Appendix}.
\end{appendix}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example with multiple Appendixes:        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{appendix}
\section{Title of the first appendix}\label{appA}
If there are more than one appendix, then please refer to it
as \ldots\ in Appendix \ref{appA}, Appendix \ref{appB}, etc.

\section{Title of the second appendix}\label{appB}
\subsection{First subsection of Appendix \protect\ref{appB}}\label{appB1}

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard \LaTeX\ commands for headings in \verb|{appendix}|.
Headings and other objects will be numbered automatically.
\begin{equation}
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}). \label{path}
\end{equation}

Sample of cross-reference to formula (\ref{path}) in Appendix \ref{appB1}.
Note that it is better to refer to Appendix \ref{appB1} as opposed to Appendix \ref{appB}, because it is easier for the reader to locate the necessary place. \end{appendix}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography:                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMPORTANT: References in the bibliography should be complete, 
%% including the first and last names, and date of publication.

%% If your bibliography is in bibtex format, uncomment commands:
%\bibliographystyle{qe} % Style BST file
%\bibliography{bibliography}  % Bibliography file (usually '*.bib')

%% Or include bibliography directly:

\begin{thebibliography}{}
%
\bibitem[\protect\citeauthoryear{Aumann}{1987}]{b1}
Aumann, Robert (1987),
``Correlated equilibrium as an expression of Bayesian rationality.''
\textit{Econometrica}, 55 (1), 1--18.
\endbibitem

\bibitem[\protect\citeauthoryear{Peck}{1994}]{b2}
Peck, James (1994),
``Competition in transactions mechanisms: The emergence of competition.''
Unpublished Manuscript, Ohio State University.
\endbibitem

\bibitem[\protect\citeauthoryear{Enelow and Hinich}{1990}]{b3}
Enelow, James, and Melvin Hinich, eds. (1990),
\textit{Advances in the Spatial Theory of Voting}.
Cambridge University Press, Cambridge, U.K.
\endbibitem

\bibitem[\protect\citeauthoryear{Wittman}{1990}]{b4}
Wittman, Donald (1990),
``Spatial strategies when candidates have policy preferences.''
In \textit{Advances in the Spatial Theory of Voting}
(M. Hinich and J. Enelow, eds.), 66--98,
Cambridge University Press, Cambridge, U.K.
\endbibitem

\bibitem[\protect\citeauthoryear{Cahuc, Postel-Vinay and Robin}{2006}]{b5}
Cahuc, P., F. Postel-Vinay, and J.-M. Robin (2006), 
``Supplement to `Wage bargaining with on-the-job search: Theory and evidence'.''
\textit{Quantitative Economics Supplemental Material}.
\endbibitem
\end{thebibliography}

\end{document}


