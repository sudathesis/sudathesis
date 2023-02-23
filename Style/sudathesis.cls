%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Huangrui Mo <huangrui.mo@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{sudathesis}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{sudathesis}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifsuda@print \suda@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \suda@printtrue%
}
%-
%-> Language
%-
\newif\ifsuda@plain \suda@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \suda@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifsuda@versioninfo \suda@versioninfofalse
\DeclareOption{draftversion}{%
    \suda@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{sudathesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\sudaifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\sudaifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\sudalntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\newcommand{\sudalntotabadvisor}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextenda{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\newcommand{\sudalntotababs}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          {\ulextendb{##1} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\newcommand{\sudalntotac}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextendc{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/sudathesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifsuda@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.5em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{0em}% horizontal shift on underline
\newcommand{\ulextend}[2][327pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
\newcommand{\ulextenda}[2][280pt]{% extend underline length
\hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
\newcommand{\ulextendb}[2][35pt]{% extend underline length
\hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
\newcommand{\ulextendc}[2][380pt]{% extend underline length
\hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
\newcommand{\siba}{\fontsize{50pt}{50pt}\selectfont}
\newcommand{\wuliu}{\fontsize{59pt}{59pt}\selectfont}
%---------------------------------------------------------------------------%
%-
%-> Blind review item commands
%-
\def\suda@value@ch@titlebr{}
\newcommand{\titlebr}[1]{\def\suda@value@ch@titlebr{#1}}
\def\suda@value@ch@brstudentnum{}
\newcommand{\brstudentnum}[1]{\def\suda@value@ch@brstudentnum{#1}}
\def\suda@value@ch@brmajor{}
\newcommand{\brmajor}[1]{\def\suda@value@ch@brmajor{#1}}
\def\suda@value@ch@brdirection{}
\newcommand{\brdirection}[1]{\def\suda@value@ch@brdirection{#1}}
\def\suda@value@ch@brkeywords{}
\newcommand{\brkeywords}[1]{\def\suda@value@ch@brkeywords{#1}}
%-
%-> Chinese item commands
%-
\def\suda@value@ch@confidential{}
\newcommand{\confidential}[1]{\def\suda@value@ch@confidential{#1}}
\def\suda@value@ch@schoolid{}
\newcommand{\schoolid}[1]{\def\suda@value@ch@schoolid{#1}}
\def\suda@value@ch@classid{}
\newcommand{\classid}[1]{\def\suda@value@ch@classid{#1}}
\def\suda@value@ch@type{}
\newcommand{\type}[1]{\def\suda@value@ch@type{#1}}
\def\suda@value@ch@schoolname{}
\newcommand{\schoolname}[2][]{\def\suda@value@ch@schoolname{\sudaifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\suda@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\suda@value@ch@schoollogo{\sudaifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\suda@value@ch@title{}
\def\suda@value@ch@titlemark{}
\renewcommand{\title}[2][\suda@value@ch@title]{%
    \def\suda@value@ch@title{#2}
    %\def\suda@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\suda@value@ch@titlemark{#1}}
\def\suda@value@ch@titlea{}
\newcommand{\titlea}[1]{\def\suda@value@ch@titlea{#1}}
\def\suda@value@ch@author{}
\renewcommand{\author}[1]{\def\suda@value@ch@author{#1}}
\def\suda@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\suda@value@ch@advisor{#1}}
\def\suda@value@ch@advisors{}
\newcommand{\advisors}[1]{\long\def\suda@value@ch@advisors{#1}}
\def\suda@value@ch@degree{}
\newcommand{\degree}[1]{\def\suda@value@ch@degree{#1}}
\def\suda@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\suda@value@ch@degreetype{#1}}
\def\suda@value@ch@subject{}
\newcommand{\subject}[1]{\def\suda@value@ch@subject{#1}}
\def\suda@value@ch@major{}
\newcommand{\major}[1]{\def\suda@value@ch@major{#1}}
\def\suda@value@ch@direction{}
\newcommand{\direction}[1]{\long\def\suda@value@ch@direction{#1}}
\def\suda@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\suda@value@ch@institute{#1}}
\def\suda@value@ch@school{}
\newcommand{\school}[1]{\def\suda@value@ch@school{#1}}
\def\suda@value@ch@orginization{}
\newcommand{\orginization}[1]{\def\suda@value@ch@orginization{#1}}
\def\suda@value@ch@completedate{}
\newcommand{\completedate}[1]{\def\suda@value@ch@completedate{#1}}
\def\suda@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\suda@value@ch@submitdate{#1}}
\def\suda@value@ch@studydatefrom{}
\newcommand{\studydatefrom}[1]{\def\suda@value@ch@studydatefrom{#1}}
\def\suda@value@ch@studydateto{}
\newcommand{\studydateto}[1]{\def\suda@value@ch@studydateto{#1}}
\def\suda@value@ch@date{}
\renewcommand{\date}[1]{\def\suda@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\suda@value@en@title{}
\def\suda@value@en@titlemark{}
\newcommand{\TITLE}[2][\suda@value@en@title]{%
    \def\suda@value@en@title{#2}
    %\def\suda@value@en@titlemark{\MakeUppercase{#1}}}
    \def\suda@value@en@titlemark{#1}}
\def\suda@value@en@author{}
\newcommand{\AUTHOR}[1]{\def\suda@value@en@author{#1}}
\def\suda@value@en@titlea{}
\newcommand{\TITLEA}[1]{\def\suda@value@en@titlea{#1}}
\def\suda@value@en@advisor{}
\newcommand{\ADVISOR}[1]{\def\suda@value@en@advisor{#1}}
\def\suda@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\suda@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\suda@value@en@degreetype{}
\newcommand{\DEGREETYPE}[1]{\def\suda@value@en@degreetype{#1}}
\def\suda@value@en@thesistype{}
\newcommand{\THESISTYPE}[1]{\def\suda@value@en@thesistype{#1}}
\def\suda@value@en@major{}
\newcommand{\MAJOR}[1]{\def\suda@value@en@major{#1}}
\def\suda@value@en@institute{}
\newcommand{\INSTITUTE}[1]{\def\suda@value@en@institute{#1}}
\def\suda@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\suda@value@en@school{#1}}
\def\suda@value@en@date{}
\newcommand{\DATE}[1]{\def\suda@value@en@date{#1}}
%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \sudaifstreq{\suda@value@en@degree}{Bachelor}{%
        \def\suda@label@ch@thesis{\suda@label@ch@thesis@bac}%
        \def\suda@label@ch@author{\suda@label@ch@author@bac}%
        \def\suda@label@ch@major{\suda@label@ch@major@bac}%
        \def\suda@label@ch@institute{\suda@label@ch@institute@bac}%
        \def\suda@value@en@thesistype{\suda@value@en@thesistype@bac}%
        \def\blindreview{\blindreview@xpdc}
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \sudaifstreq{\suda@value@en@degree}{Master}{%
        \def\suda@label@ch@thesis{\suda@label@ch@thesis@mas}%
        \def\suda@label@ch@author{\suda@label@ch@author@mas}%
        \def\suda@label@ch@major{\suda@label@ch@major@mas}%
        \def\suda@label@ch@institute{\suda@label@ch@institute@mas}%
        \def\suda@value@en@thesistype{\suda@value@en@thesistype@mas}%
        \def\blindreview{\blindreview@xpdc}
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \sudaifstreq{\suda@value@en@degree}{Doctor}{%
        \def\suda@label@ch@thesis{\suda@label@ch@thesis@doc}%
        \def\suda@label@ch@author{\suda@label@ch@author@doc}%
        \def\suda@label@ch@major{\suda@label@ch@major@doc}%
        \def\suda@label@ch@institute{\suda@label@ch@institute@doc}%
        \def\suda@value@en@thesistype{\suda@value@en@thesistype@doc}%
        \def\blindreview{\blindreview@xpdc}
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
        \ClassWarning{sudathesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}%
}
%-
%-> Define Blind review style
%-
\newcommand{\blindreview@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
       \linespread{1.6}
       \zihao{-4}
       \vspace*{\stretch{1}}

       {\wuliu {\suda@label@ch@thesis}}

       \vspace*{\stretch{0.5}}

       {\zihao{2}\suda@value@ch@type}

       \vspace*{\stretch{1.0}}

       \def\tabcolsep{1pt}
       \def\arraystretch{1.5}
       \begin{tabular}{p{0.0cm}p{13cm}}
             & \sudalntotac[1.5pt]{\suda@value@ch@titlebr}\\
             & \sudalntotac[1.5pt]{\suda@value@en@titlea}\\
       \end{tabular}

       \vspace*{\stretch{1.0}}

       \def\tabcolsep{1pt}
        \def\arraystretch{1.5}
        \begin{tabular}{p{3.38cm}p{9.09cm}}
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@brstudentnum}       & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@brstudentnum}}\\ 
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@brmajor}        & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@brmajor}}\\
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@brdirection}    & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@brdirection}}\\
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@brkeywords}      & \sudalntotabadvisor[1.5pt]{{\suda@value@ch@brkeywords}}\\
        \end{tabular}


        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%-
%-> Define Chinese style
%-
\newcommand{\maketitle@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
       \linespread{1.6}
       \zihao{-4}

    \vspace*{-2.8cm}
    \hspace{20.5em}
    \parbox{5\ccwd}{{\sffamily\zihao{-4} \suda@label@ch@schoolid}} {\zihao{-4} {\suda@value@ch@schoolid}} \par
    \hspace{23.5em}
    \parbox{5\ccwd}{{\sffamily\zihao{-4} \suda@label@ch@classid}} {\zihao{-4} {\suda@value@ch@classid}} \par


        \vspace*{\stretch{4}}

        {\suda@value@ch@schoolname}

        \vspace*{\stretch{4}}

        {\siba {\suda@label@ch@thesis}}

        \vspace*{\stretch{1}}

        {\zihao{2}\suda@value@ch@type}

        \vspace*{\stretch{1}}

        {\suda@value@ch@schoollogo}

        \vspace*{\stretch{2}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.0}
        \begin{tabular}{p{1.75cm}p{10.74cm}}
               & \sudalntotab[1.5pt]{\suda@value@ch@titlea}\\
               & \sudalntotab[1.5pt]{\suda@value@en@titlea}\\
        \end{tabular}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.0}
        \begin{tabular}{p{3.38cm}p{9.09cm}}
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@author}       & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@author}}\\ 
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@advisor}      & \sudalntotabadvisor[1.5pt]{{\suda@value@ch@advisor}}\\
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@major}        & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@major}}\\
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@direction}    & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@direction}}\\
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@institute}    & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@institute}}\\
            \makebox[3.38cm][s]{\zihao{4}\sffamily \suda@label@ch@submitdate}   & \ulenhance[1.5pt]{\ulextenda{\suda@value@ch@date}}\\
        \end{tabular}


        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifsuda@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifsuda@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifsuda@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%-
%-> Define English style
%-
\newcommand{\MAKETITLE@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \vspace*{50pt}

        {\zihao{3}\bfseries{\suda@value@en@title}}

        \vspace*{\stretch{3}}

        {\suda@label@en@statement}

        {By}

        {\zihao{3}\suda@value@en@author}

        {Supervisor}

        {By}

        {\zihao{3}\suda@value@en@advisor}

        \vspace*{\stretch{3}}

        {\suda@value@en@institute}

        \vspace*{\stretch{1}}

        {\suda@value@en@date}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.6}
        \zihao{5}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4} \suda@label@ch@declare@creativityandrights}
        \end{center}

        \begin{center}
            {\zihao{-4}\bfseries \suda@label@ch@declare@creativity}
        \end{center}

        {\suda@value@ch@declare@creativity}

        \par 
        \hfill
        \begin{tabular} {p{3.00cm}p{3.00cm}p{1.5cm}p{2.0cm}}%
            \makebox[3.00cm][s]{\zihao{-4} \suda@label@ch@authorsign}       &   &  \makebox[1.5cm][s]{\zihao{-4} \suda@label@ch@date}       &  \\ \cline{2-2} \cline{4-4}
        \end{tabular}

        \vspace*{6ex}

        \begin{center}
            {\zihao{-4}\bfseries \suda@label@ch@declare@rights}
        \end{center}

        {\suda@value@ch@declare@rights}

        \par 
        \begin{tabular}{llcp{1.0cm}cp{0.5cm}l}
                & \bfseries 涉密论文$\square$   &   &  &   &  &            \\
                \bfseries 本学位论文属 &       & \bfseries 在 &  & \bfseries 年 &  & \bfseries 月解密后适用本规定。 \\ \cline{4-4} \cline{6-6}
                & \bfseries 非涉密论文$\square$  &   &  &   &  &           
        \end{tabular}
        \par 
        \hfill
          \begin{tabular} {p{3.00cm}p{3.00cm}p{1.5cm}p{2.0cm}}%
            \makebox[3.00cm][s]{\zihao{-4} \suda@label@ch@authorsign}       &   &  \makebox[1.5cm][s]{\zihao{-4} \suda@label@ch@date}       &  \\ \cline{2-2} \cline{4-4}
            \makebox[3.00cm][s]{\zihao{-4} \suda@label@ch@advisorsign}       &   &  \makebox[1.5cm][s]{\zihao{-4} \suda@label@ch@date}       &  \\ \cline{2-2} \cline{4-4}
          \end{tabular}
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%---------------------------------------------------------------------------%
%->>Define Chinese Abstract
\def\suda@value@ch@abstract{}
\newcommand{\abstract}[1]{\def\suda@value@ch@abstract{#1}}
\def\suda@value@ch@keywords{}
\newcommand{\keywords}[1]{\def\suda@value@ch@keywords{#1}}
\def\suda@value@ch@absauthor{}
\newcommand{\absauthor}[1]{\def\suda@value@ch@absauthor{#1}}
\def\suda@value@ch@absadvisor{}
\newcommand{\absadvisor}[1]{\def\suda@value@ch@absadvisor{#1}}
%---------------------------------------------------------------------------%
\newcommand{\makeabstract}{%
    \cleardoublepage
    \thispagestyle{empty}
    {

%        \intobmk\chapter*{摘\quad 要}% 显示在书签但不显示在目录
        \chapter{摘\quad 要}% 显示在书签且显示在目录
        \setcounter{page}{1}% 开始页码
        \pagenumbering{Roman}% 页码符号
        
        {\suda@value@ch@abstract}


        {\vspace{\baselineskip}\noindent {\bfseries \suda@label@ch@keywords}}{\suda@value@ch@keywords}

%        \par
%        \hfill
%        {\suda@label@ch@absauthor \suda@value@ch@absauthor}
%        \par
%        \hfill
%        {\suda@label@ch@absadvisor \suda@value@ch@absadvisor}
        \par
        \hfill
        \def\tabcolsep{1pt}
        \def\arraystretch{1.0}
        \begin{tabular}{rc}
            {\suda@label@ch@absauthor}       & \sudalntotababs{\suda@value@ch@absauthor}\\ 
            {\suda@label@ch@absadvisor}      & \sudalntotababs{\suda@value@ch@absadvisor}\\
        \end{tabular}



    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->>Define English Abstract
\def\suda@value@en@ABSTRACT{}
\newcommand{\ABSTRACT}[1]{\def\suda@value@en@abstract{#1}}
\def\suda@value@en@keywords{}
\newcommand{\KEYWORDS}[1]{\def\suda@value@en@keywords{#1}}
\def\suda@value@en@absauthor{}
\newcommand{\ABSAUTHOR}[1]{\def\suda@value@en@absauthor{#1}}
\def\suda@value@en@absadvisor{}
\newcommand{\ABSADVISOR}[1]{\def\suda@value@en@absadvisor{#1}}
%---------------------------------------------------------------------------%
\newcommand{\MAKEABSTRACT}{%
    \cleardoublepage
    \thispagestyle{empty}
    {

%        \intobmk\chapter*{Abstract}% 显示在书签但不显示在目录
        \chapter{Abstract}% 显示在书签且显示在目录

        {\suda@value@en@abstract}

        {\vspace{\baselineskip}\noindent {\bfseries \suda@label@en@keywords}}{\suda@value@en@keywords}

%        \par
%        \hfill
%        {Written by \suda@value@en@absauthor}
%        \par
%        \hfill
%        {Supervised by \suda@value@en@absadvisor}
        \par
        \hfill
        \def\tabcolsep{1pt}
        \def\arraystretch{1.0}
        \begin{tabular}{rc}
            {\suda@label@en@absauthor}       & \sudalntotababs{\suda@value@en@absauthor}\\ 
            {\suda@label@en@absadvisor}      & \sudalntotababs{\suda@value@en@absadvisor}\\
        \end{tabular}


    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifsuda@plain%
    \def\contentsname{\suda@label@en@tocname}
    \def\listfigurename{\suda@label@en@lsfigname}
    \def\listtablename{\suda@label@en@lstabname}
    \def\bibname{\suda@label@en@bibname}
    \def\refname{\suda@label@en@bibname}
    \def\algname{\suda@label@en@algname}
    \def\bibetal{\suda@label@en@bibetal}
    \def\biband{\suda@label@en@biband}
    \def\axiomname{\suda@label@en@axiomname}
    \def\theoremname{\suda@label@en@theoremname}
    \def\lemmaname{\suda@label@en@lemmaname}
    \def\corollaryname{\suda@label@en@corollaryname}
    \def\assertionname{\suda@label@en@assertionname}
    \def\propositionname{\suda@label@en@propositionname}
    \def\conjecturename{\suda@label@en@conjecturename}
    \def\definitionname{\suda@label@en@definitionname}
    \def\examplename{\suda@label@en@examplename}
    \def\remarkname{\suda@label@en@remarkname}
    \def\proofname{\suda@label@en@proofname}
    \def\@title{\suda@value@en@titlemark}
    \def\@author{\suda@value@en@author}
\else
    \def\contentsname{\suda@label@ch@tocname}
    \def\listfigurename{\suda@label@ch@lsfigname}
    \def\listtablename{\suda@label@ch@lstabname}
    \def\algname{\suda@label@ch@algname}
    \def\bibname{\suda@label@ch@bibname}
    \def\refname{\suda@label@ch@bibname}
    \def\bibetal{\suda@label@ch@bibetal}
    \def\biband{\suda@label@ch@biband}
    \def\axiomname{\suda@label@ch@axiomname}
    \def\theoremname{\suda@label@ch@theoremname}
    \def\lemmaname{\suda@label@ch@lemmaname}
    \def\corollaryname{\suda@label@ch@corollaryname}
    \def\assertionname{\suda@label@ch@assertionname}
    \def\propositionname{\suda@label@ch@propositionname}
    \def\conjecturename{\suda@label@ch@conjecturename}
    \def\definitionname{\suda@label@ch@definitionname}
    \def\examplename{\suda@label@ch@examplename}
    \def\remarkname{\suda@label@ch@remarkname}
    \def\proofname{\suda@label@ch@proofname}
    \def\@title{\suda@value@ch@titlemark}
    \def\@author{\suda@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{-2}\sffamily\centering,
        nameformat = {},
        titleformat = {},
%        number = \arabic{chapter},
        number = \zhnum{chapter},
        numberformat = \sffamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{3}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{-4} #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{-4}
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput

