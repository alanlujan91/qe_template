
(appn)=
# Title 

Appendices should be provided in `{appendix}` environment. If there is only one appendix,
then please refer to it in text as ... in the {ref}`appn`.

(appA)=
# Title of the first appendix 

If there are more than one appendix, then please refer to it
as ... in Appendix {ref}`appA`, Appendix {ref}`appB`, etc.

(appB)=
# Title of the second appendix 

(appB1)=
## First subsection of Appendix {ref}`appB`

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard LaTeX commands for headings in `{appendix}`.
Headings and other objects will be numbered automatically.

$$
\begin{equation}
\label{path}
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}).
\end{equation}
$$

Sample of cross-reference to formula {ref}`path` in Appendix {ref}`appB1`.
Note that it is better to refer to Appendix {ref}`appB1` as opposed to Appendix {ref}`appB`, because it is easier for the reader to locate the necessary place. 
