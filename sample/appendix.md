# Title {-}

Appendices should be provided in `{appendix}` environment. If there is only one appendix,
then please refer to it in text as ... in the \hyperref[appn]{Appendix}.

# Title of the first appendix {#appA}

If there are more than one appendix, then please refer to it
as ... in Appendix \ref{appA}, Appendix \ref{appB}, etc.

# Title of the second appendix {#appB}

## First subsection of Appendix \ref{appB} {#appB1}

If your appendix is long, make sure to divide it into subsections and refer to them in text. Use the standard LaTeX commands for headings in `{appendix}`.
Headings and other objects will be numbered automatically.

$$
\mathcal{P}=(j_{k,1},j_{k,2},\dots,j_{k,m(k)}). \label{path}
$$

Sample of cross-reference to formula (\ref{path}) in Appendix \ref{appB1}.
Note that it is better to refer to Appendix \ref{appB1} as opposed to Appendix \ref{appB}, because it is easier for the reader to locate the necessary place. 