%% forked from https://gits-15.sys.kth.se/giampi/kthlatex kthlatex-0.2rc4 on 2020-02-13
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kththesis}[2018/04/26 KTH Thesis formatting]

\newif\ifdigitaloutput
\DeclareOption{digitaloutput}{\digitaloutputtrue}

\newif\ifinswedish
\DeclareOption{english}{}
\DeclareOption{swedish}{\inswedishtrue}

\newif\ifgfivepaper
\DeclareOption{a4paper}{}
\DeclareOption{g5paper}{\gfivepapertrue}

\newif\ifbiblatex
\DeclareOption{bibtex}{}
\DeclareOption{biblatex}{\biblatextrue}

%% Send any unknown option to the report class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

%\ProcessOptions\relax
\ProcessOptions*

\ifgfivepaper
  \LoadClass[10pt]{report}
  \makeatletter %only needed in preamble
    \renewcommand\huge{\@setfontsize\huge{24pt}{25}}
  \makeatother
\else
  \LoadClass[12pt]{report}
\fi

% to do string comparison
\usepackage{xstring}


% Make it possible to conditionally depend on the TeX-engine used
\RequirePackage{ifxetex}
\RequirePackage{ifluatex}
\newif\ifxeorlua
\ifxetex\xeorluatrue\fi
\ifluatex\xeorluatrue\fi

%% Load other packages


\ifxeorlua
  \RequirePackage{polyglossia}
  \ifinswedish
    \setmainlanguage{swedish}
    \setotherlanguage[variant=us]{english}
    \setotherlanguages{french,spanish,italian,norsk,german,danish,dutch,estonian}
  \else
    %\setmainlanguage[variant=american]{english}
    \setmainlanguage[variant=us]{english}
    \setotherlanguages{swedish,french,spanish,italian,norsk,german,danish,dutch,estonian}

  \fi

\else
  \RequirePackage[utf8]{inputenc}
  \ifinswedish
     \RequirePackage[main=swedish,english,french,spanish,italian,norsk,ngerman,danish,dutch,estonian]{babel}
  \else
    \RequirePackage[swedish,main=english,french,spanish,italian,norsk,ngerman,danish,dutch,estonian]{babel}
  \fi
\fi

\ifgfivepaper
\RequirePackage[paperwidth=169mm,paperheight=239mm,twoside,
  top=30mm,bottom=30mm,inner=36mm,outer=18mm,
  headsep=10mm,headheight=5mm]{geometry} % Set paper and contents dimensions
\else
\RequirePackage[a4paper,twoside,
  top=37mm,bottom=50mm,inner=45mm,outer=35mm,
  headsep=15mm,headheight=6mm,footskip=25mm]{geometry} % Set paper and contents dimensions
\fi
\RequirePackage{fancyhdr} % Take control of headers and footers
%\RequirePackage{emptypage} % Supress page numbers on otherwise empty pages

\RequirePackage{pdfpages} % Used to include the preformatted KTH cover pages

\RequirePackage{titlesec} % Redefine the appearance of headers
% === Patch to circumvent a bug in the titlesec package version 2.10.1
\@ifpackagelater{titlesec}{2016/03/21}{%
 % Package titlesec is on version 2.10.2 or higher, nothing to do %
}{%
 % Check if package titlesec is on version 2.10.1 %
 \@ifpackagelater{titlesec}{2016/03/15}{%
  % Package titlesec on version 2.10.1, patch accordingly %
  \RequirePackage{etoolbox}%
  \patchcmd{\ttlh@hang}{\parindent\z@}{\parindent\z@\leavevmode}{}{}%
  \patchcmd{\ttlh@hang}{\noindent}{}{}{}%
 }{%
  % Package titlsecon is on version 2.10.0 or lower, nothing to do %
 }%
}
% === End ot titlesec patch

\ifxeorlua
  \RequirePackage{fontspec}
  \defaultfontfeatures{Ligatures={TeX}} % This enables TeX style ligatures such as ---, '', ``, and so on
  \setmainfont{TeX Gyre Termes}  %% Times like font
  \setsansfont{TeX Gyre Heros}   %% Helvetica like font
  \setmonofont{TeX Gyre Cursor}  %% Courier like font
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{tgtermes}
  \RequirePackage{tgheros}
  \RequirePackage{tgcursor}
\fi

% Set up the header and footer
\fancyhead{}
\fancyhead[RO]{\sffamily\small\leftmark\thinspace|\thinspace\thepage}
\fancyhead[LE]{\sffamily\small\thepage\thinspace|\thinspace\leftmark}
\fancyfoot{}
\renewcommand{\headrulewidth}{0pt}
\pagestyle{fancy}

% Add 5% extra linespacing
\linespread{1.05}

% Set the proper format for the headers
\titleformat{\chapter}[display]
  {\normalfont\sffamily\huge\bfseries}
  {\chaptertitlename\ \thechapter}{20pt}{\Huge}
\titleformat{\section}
  {\normalfont\sffamily\Large\bfseries}
  {\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont\sffamily\large\bfseries}
  {\thesubsection}{1em}{}
\titleformat{\subsubsection}
  {\normalfont\sffamily\normalsize\bfseries}
  {\thesubsection}{1em}{}

\renewenvironment{abstract}{\section*{\abstractname}}

% Define commands for setting the user definable parts of the title page
\let\@subtitle\@empty
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}
\let\@alttitle\@empty
\newcommand{\alttitle}[1]{\def\@alttitle{#1}}
\let\@altsubtitle\@empty
\newcommand{\altsubtitle}[1]{\def\@altsubtitle{#1}}


\let\@authorsLastname\@empty
\newcommand{\authorsLastname}[1]{\def\@authorsLastname{#1}}
\let\@authorsFirstname\@empty
\newcommand{\authorsFirstname}[1]{\def\@authorsFirstname{#1}}
\let\@email\@empty
\newcommand{\email}[1]{\def\@email{#1}}
\let\@kthid\@empty
\newcommand{\kthid}[1]{\def\@kthid{#1}}
\let\@orcid\@empty
\newcommand{\orcid}[1]{\def\@orcid{#1}}

\let\@school\@empty
\newcommand{\school}[1]{\def\@school{#1}}
\let\@authorsDepartment\@empty
\newcommand{\authorsDepartment}[1]{\def\@authorsDepartment{#1}}

\let\@supervisorAsLastname\@empty
\newcommand{\supervisorAsLastname}[1]{\def\@supervisorAsLastname{#1}}
\let\@supervisorAsFirstname\@empty
\newcommand{\supervisorAsFirstname}[1]{\def\@supervisorAsFirstname{#1}}
\let\@supervisorAsEmail\@empty
\newcommand{\supervisorAsEmail}[1]{\def\@supervisorAsEmail{#1}}
\let\@supervisorAsKTHID\@empty
\newcommand{\supervisorAsKTHID}[1]{\def\@supervisorAsKTHID{#1}}
\let\@supervisorAsOrganization\@empty
\newcommand{\supervisorAsOrganization}[1]{\def\@supervisorAsOrganization{#1}}
\let\@supervisorAsSchool\@empty
\newcommand{\supervisorAsSchool}[1]{\def\@supervisorAsSchool{#1}}
\let\@supervisorAsDepartment\@empty
\newcommand{\supervisorAsDepartment}[1]{\def\@supervisorAsDepartment{#1}}

\let\@supervisorBsLastname\@empty
\newcommand{\supervisorBsLastname}[1]{\def\@supervisorBsLastname{#1}}
\let\@supervisorBsFirstname\@empty
\newcommand{\supervisorBsFirstname}[1]{\def\@supervisorBsFirstname{#1}}
\let\@supervisorBsEmail\@empty
\newcommand{\supervisorBsEmail}[1]{\def\@supervisorBsEmail{#1}}
\let\@supervisorBsKTHID\@empty
\newcommand{\supervisorBsKTHID}[1]{\def\@supervisorBsKTHID{#1}}
\let\@supervisorBsOrganization\@empty
\newcommand{\supervisorBsOrganization}[1]{\def\@supervisorBsOrganization{#1}}
\let\@supervisorBsSchool\@empty
\newcommand{\supervisorBsSchool}[1]{\def\@supervisorBsSchool{#1}}
\let\@supervisorBsDepartment\@empty
\newcommand{\supervisorBsDepartment}[1]{\def\@supervisorBsDepartment{#1}}

\let\@supervisorCsLastname\@empty
\newcommand{\supervisorCsLastname}[1]{\def\@supervisorCsLastname{#1}}
\let\@supervisorCsFirstname\@empty
\newcommand{\supervisorCsFirstname}[1]{\def\@supervisorCsFirstname{#1}}
\let\@supervisorCsEmail\@empty
\newcommand{\supervisorCsEmail}[1]{\def\@supervisorCsEmail{#1}}
\let\@supervisorCsKTHID\@empty
\newcommand{\supervisorCsKTHID}[1]{\def\@supervisorCsKTHID{#1}}
\let\@supervisorCsOrganization\@empty
\newcommand{\supervisorCsOrganization}[1]{\def\@supervisorCsOrganization{#1}}
\let\@supervisorCsSchool\@empty
\newcommand{\supervisorCsSchool}[1]{\def\@supervisorCsSchool{#1}}
\let\@supervisorCsDepartment\@empty
\newcommand{\supervisorCsDepartment}[1]{\def\@supervisorCsDepartment{#1}}

\let\@opponentsLastname\@empty
\newcommand{\opponentsLastname}[1]{\def\@opponentsLastname{#1}}
\let\@opponentsFirstname\@empty
\newcommand{\opponentsFirstname}[1]{\def\@opponentsFirstname{#1}}
\let\@opponentsEmail\@empty
\newcommand{\opponentsEmail}[1]{\def\@opponentsEmail{#1}}
% if outside KTH
\let\@opponentsOrganization\@empty
\newcommand{\opponentsOrganization}[1]{\def\@opponentsOrganization{#1}}
% if inside KTH
\let\@opponentsSchool\@empty
\newcommand{\opponentsSchool}[1]{\def\@opponentsSchool{#1}}
\let\@opponentsDepartment\@empty
\newcommand{\opponentsDepartment}[1]{\def\@opponentsDepartment{#1}}

\let\@programme\@empty
\newcommand{\programme}[1]{\def\@programme{#1}}
%
\let\@thesistype\@empty
\newcommand{\thesistype}[1]{\def\@thesistype{#1}}

\let\@examen\@empty
\newcommand{\examen}[1]{\def\@examen{#1}}

\let\@disputationsdatum\@empty
\newcommand{\disputationsdatum}[1]{\def\@disputationsdatum{#1}}

\let\@disputationslokal\@empty
\newcommand{\disputationslokal}[1]{\def\@disputationslokal{#1}}
% Presentation":{
%	"Date": "2019-07-25 4:31",
%	"Language": "eng",
%	"Room": "Seminar room Grimeton at COM",
%	"Address": "Kistagången 16, East, Floor 4, Elevator B",
%	"City": "Kista"

\let\@presentationDateAndTimeISO\@empty
\newcommand{\presentationDateAndTimeISO}[1]{\def\@presentationDateAndTimeISO{#1}}
\let\@presentationLanguage\@empty
\newcommand{\presentationLanguage}[1]{\def\@presentationLanguage{#1}}
\let\@presentationRoom\@empty
\newcommand{\presentationRoom}[1]{\def\@presentationRoom{#1}}
\let\@presentationAddress\@empty
\newcommand{\presentationAddress}[1]{\def\@presentationAddress{#1}}
\let\@presentationCity\@empty
\newcommand{\presentationCity}[1]{\def\@presentationCity{#1}}

\let\@imprint\@empty
\newcommand{\imprint}[1]{\def\@imprint{#1}}

\let\@isbn\@empty
\newcommand{\isbn}[1]{\def\@isbn{#1}}

\let\@isrn\@empty
\newcommand{\isrn}[1]{\def\@isrn{#1}}

\let\@issn\@empty
\newcommand{\issn}[1]{\def\@issn{#1}}

\let\@publisher\@empty
\newcommand{\publisher}[1]{\def\@publisher{#1}}

\let\@publicationYear\@empty
\newcommand{\publicationYear}[1]{\def\@publicationYear{#1}}

\let\@publicationMonth\@empty
\newcommand{\publicationMonth}[1]{\def\@publicationMonth{#1}}


\let\@trita\@empty
\newcommand{\trita}[1]{\def\@trita{#1}}

\let\@address\@empty
\newcommand{\address}[1]{\def\@address{#1}}


% Data for DIVA National Subject Cateories fields
\let\@nationalsubjectcategories\@empty
\newcommand{\nationalsubjectcategories}[1]{\def\@nationalsubjectcategories{#1}}

% Keywords
\let\@EnglishKeywords\@empty
\newcommand{\EnglishKeywords}[1]{\def\@EnglishKeywords{#1}}

\let\@SwedishKeywords\@empty
\newcommand{\SwedishKeywords}[1]{\def\@SwedishKeywords{#1}}

\makeatletter
\newcommand{\InsertKeywords}[1]{
    \IfEqCase{#1}{%
    {english}{\@EnglishKeywords}
    {swedish}{\@SwedishKeywords}
  }[\typeout{argument must be english or swedish}]
}


% deal with optional fields
\let\thesubtitle\relax

% deal with required fields
\def\thethesistype{\ClassError{kththesis}%
  {\protect\thesistype\space not given}%
  {Please Read The Fine Manual.}}
\def\theexamen{\ClassError{kththesis}%
  {\protect\examen\space not given}%
  {Please Read The Fine Manual.}}
\def\thedisputationsdatum{\ClassError{kththesis}
  {\protect\thedisputationsdatum\space not given}%
  {Please Read The Fine Manual.}}
\def\thedisputationslokal{\ClassError{kththesis}
  {\protect\thedisputationslokal\space not given}%
  {Please Read The Fine Manual.}}
\def\theimprint{\ClassError{kththesis}%
  {\protect\theimprint\space not given}%
  {Please Read The Fine Manual.}}
\def\thepublisher{\ClassError{kththesis}%
  {\protect\thepublisher\space not given}%
  {Please Read The Fine Manual.}}
  



%\newcommand{\programcode}[1]{\def\@programcode{#1}}
%\newcommand{\decide}[3]{%
%  \IfStrEq{\@programcode}{#1}{#2}{#3}%
%}

% get all of the information about the school codes and program codes
\input{lib/schools_and_programs_3rd_cycle.ins}


\newcommand{\MONTH}{%
  \ifinswedish
  \ifcase \@publicationMonth
  \or januari% 1
  \or februari% 2
  \or mars% 3
  \or april% 4
  \or maj% 5
  \or juni% 6
  \or juli% 7
  \or augusti% 8
  \or september% 9
  \or oktober% 10
  \or november% 11
  \or december% 12
  \fi
  \else
  \ifcase\the\month
  \or January% 1
  \or February% 2
  \or March% 3
  \or April% 4
  \or May% 5
  \or June% 6
  \or July% 7
  \or August% 8
  \or September% 9
  \or October% 10
  \or November% 11
  \or December% 12
  \fi
\fi
}

% covers are separately made and applied
%\let\@kthcover\@empty
%\newcommand{\kthcover}[1]{\def\@kthcover{#1}}

% Command to print out the standardized title page
\renewcommand{\titlepage}{
 \ifgfivepaper
  \newgeometry{top=65mm,bottom=30mm,left=24mm,right=26mm}
 \else
  \newgeometry{top=65mm,bottom=30mm,left=50mm,right=35mm}
 \fi

 \thispagestyle{empty}
 \ifinswedish\selectlanguage{swedish}\fi
 \begin{huge}
  \begin{flushleft}
    \noindent\sffamily\bfseries \@title \par\noindent\
  \end{flushleft}
 \end{huge}
 \ifx\@subtitle\@empty\relax
 \else
 \begin{Large}
 \fi
\vspace{7mm}
  \vspace{1ex}
  \begin{flushleft}
    \noindent\sffamily\bfseries \@subtitle \par
  \end{flushleft}
 \end{Large}
\begin{large}
  \begin{flushleft}
    \sffamily
    \expandafter\MakeUppercase\expandafter\@authorsFirstname\space\expandafter\MakeUppercase\expandafter\@authorsLastname \par
  \end{flushleft}
\end{large}
\vspace{24mm}
\begin{small}
\begin{flushleft}
 \ifinswedish
 Akademisk avhandling som med tillstånd av KTH framlägges till offentlig granskning för avläggande av \@examen\enspace\@disputationsdatum\enspace\@disputationslokal.
 \else
 Academic dissertation which, with due permission of the KTH Royal Institute of Technology, is submitted for public defence for the Degree of \@examen\enspace on \@disputationsdatum\enspace\@disputationslokal.
 \fi
\end{flushleft}
\end{small}
\vfill
\begin{small}
 \begin{flushleft}
  \sffamily
  \ifinswedish
    \@thesistype~inom \@programme\\
Kungliga Tekniska högskolan (KTH) \\
Stockholm, Sverige \@publicationYear
  \else
    \@thesistype~in \@programme\\
KTH Royal Institute of Technology\\
Stockholm, Sweden \@publicationYear
  \fi
 \end{flushleft}
\end{small}
\restoregeometry
\clearpage
} %end of titlepage

% Command to print out the standardized document information page
\newcommand{\bookinfopage}{
\ifgfivepaper
  \newgeometry{top=140mm,bottom=30mm,left=12.25mm,right=35mm}
\else
  \newgeometry{top=200mm,bottom=30mm,left=50mm,right=35mm}
\fi
\thispagestyle{empty}
\begin{small}
\begin{flushleft}
\sffamily

\@alttitle
    \ifx\@altsubtitle\@empty\relax
    \else
    : \@altsubtitle


\vspace{10 mm}
\copyright\enspace\the\year\quad\@authorsFirstname\space\@authorsLastname\\
\vspace{5 mm}
\ifx\@isbn\@empty\relax
\else
\@isbn\\
\fi
\ifx\@trita\@empty\relax
\else
\@trita\\
\fi
\vspace{15 mm}
\ifx\@publisher\@empty\relax
\else
\ifinswedish
Tryck: \@publisher, Sverige \@publicationYear
\else
Printed by: \@publisher, Sweden \@publicationYear
\fi

\end{flushleft}
\end{small}
\restoregeometry
\clearpage
}

\newcommand{\acknowlegmentssignature}{
  \begin{flushleft}
    Stockholm, \MONTH\,\@publicationYear\\
    \@authorsFirstname\space\@authorsLastname
  \end{flushleft}
\cleardoublepage
}

\newcommand{\frontmatter}{
  \pagenumbering{roman}
  \setcounter{page}{1}
}

\newcommand{\mainmatter}{
  \cleardoublepage
  \pagenumbering{arabic}
}

% {
%    "Author1":{
%	"Last name": "Maguire Jr.",
%	"First name": "Gerald Q.",
%	"Local User Id": "u1d13i2c",
%	"Research group": "CCS",
%	"E-mail": "maguire@kth.se",
%	"organisation": {"L1": "School of Information and Communication Technology (ICT)",
%			 "L2": "Communication Systems, CoS"
%			}
%    },
%
%    "Cooperation":{
%	"Partner_name": "ABBBBA"
%    },
%    "Title":{
%	"Main title": "This is a long title in English",
%	"Subtitle": "This is an even longer subtitle in English",
%	"Language": "eng"	
%    },
%    "Alternative title":{
%	"Main title": "Detta är en lång titel på svenska",
%	"Subtitle": "Detta är en ännu längre undertexter på svenska",
%	"Language": "swe"
%    },
%    "Degree":{
%	"Level": "Independent thesis Basic level (degree of Bachelor)",
%	"University credits": "15 HE credits",
%	"Educational program": "Bachelor of Science in Engineering - Computer Engineering",
%	"Subject_course": "Communications Systems"
%    },
%    "Content category":{
%    },
%    "Other information":{
%	"Year": "2019",
%	"Number of pages": "xiii,72"
%    },
%    "Series":{
%	"Title of series": "TRITA-ICT-EX",
%	"No. in series": "2019:00"
%    },
%    "Other series":{
%	"Title of series": "",
%	"ISSN": "",
%	"EISSN": "",
%	"No. in series": ""
%    },
%    "Identifiers":{
%	"ISRN": "",
%	"DOI": "",
%	"DOI_Free_full_text": "",
%	"URL": "",
%	"URL label": "",
%	"URL_Free_full_text": ""
%    },
%    "National subject category":{
%	"L1": "Engineering and Technology",
%	"L2": "Electrical Engineering, Electronic Engineering, Information Engineering",
%	"L3": "Communication Systems"
%    },
%    "Part of project":{
%    },
%    "Part of other project":{
%	"Project_name": ""
%    },
%    "Keywords1":{
%	"Keywords": "Fiddle,Fee,Foo,Fum",
%	"Language": "eng"
%    },
%    "Keywords2":{
%	"Keywords": "Faddle,Fåå,Fää,Fööm",
%	"Language": "swe"
%    },
%    "Abstract1":{
%	"Abstract":	"<p>This is a abstract for an non existant thesis about <sup>18</sup>F<sup>-</sup></p>",
%	"Language": "eng"
%    },
%    "Abstract2":{
%	"Abstract":	"<p>Detta är ett abstrakt för en icke-existerande avhandling om <sup>18</sup>F<sup>-</sup></p>",
%	"Language": "swe"
%    },
%    "Supervisor1":{
%	"Last name": "Västberg",
%	"First name": "Anders",
%	"Academic title": "universitetslektor",
%	"Local User Id": "u1ft3a12",
%	"Research group": "RS",
%	"ORCiD": "0000-0002-4226-9652",
%	"E-mail": "vastberg@kth.se",
%	"organisation": {"L1": "School of Information and Communication Technology (ICT)",
%			 "L2": "Communication Systems, CoS",
%			 "L3": "Radio Systems Laboratory (RS Lab)"}
%    },
%    "Supervisor2":{
%	"Last name": "Normal",
%	"First name": "A. B.",
%	"E-mail": "ABNormal@example.org",
%	"Other organisation": "Famous Anvils"
%    },
%    "Examiner1":{
%	"Last name": "Maguire Jr.",
%	"First name": "Gerald Q.",
%	"Academic title": "professor",
%	"Local User Id": "u1d13i2c",
%	"ORCiD": "0000-0002-6066-746X",
%	"Research group": "CCS",
%	"E-mail": "maguire@kth.se",
%	"organisation": {"L1": "School of Information and Communication Technology (ICT)",
%			 "L2": "Communication Systems, CoS",
%			 "L3": "Radio Systems Laboratory (RS Lab)"}
%    },
%    "Presentation":{
%	"Date": "2019-07-25 4:31",
%	"Language": "eng",
%	"Room": "Seminar room Grimeton at COM",
%	"Address": "Kistagången 16, East, Floor 4, Elevator B",
%	"City": "Kista"
%    },
%    "Note" :{
%	"Note": "<p><span style='color: red;'>A completely bogus entry for testing with Puppeteer using diva5.js</span></p>"
%    },
%    "File" :{
%	"Filename": "/home/maguire/Diva/z2.pdf",
%	"Accept full text": "true"
%    }
%
%}

\newcommand{\divainfo}[2]{
\thispagestyle{empty}
    \sffamily\tiny
    \begin{flushleft}
    \{\\
        \textquotedbl\relax Author1\textquotedbl\relax: \{\\
        \ifx\@authorsLastname\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax Last name\textquotedbl\relax: \textquotedbl\relax\@authorsLastname\textquotedbl\relax,\\
        \fi
        \ifx\@authorsFirstname\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax First name\textquotedbl\relax: \textquotedbl\relax\@authorsFirstname\textquotedbl\relax,\\
        \fi
        \ifx\@kthid\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax Local User Id\textquotedbl\relax: \textquotedbl\relax\@kthid\textquotedbl\relax,\\
        \fi
        \ifx\@email\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax E-mail\textquotedbl\relax: \textquotedbl\relax\@email\textquotedbl\relax,\\
        \fi
        \ifx\@orcid\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax ORCiD\textquotedbl\relax: \textquotedbl\relax\@orcid\textquotedbl\relax,\\
        \fi
        \ifx\@school\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax organisation\textquotedbl\relax: \{\textquotedbl\relax L1\textquotedbl\relax: \textquotedbl\relax\@school\textquotedbl\relax,\\
            \ifx\@authorsDepartment\@empty\relax
            \else
            \hspace{2.25cm}\textquotedbl\relax L2\textquotedbl\relax: \textquotedbl\relax\@authorsDepartment\textquotedbl\relax
            \fi
			\}\\
		\fi
       \hspace{0.9cm}\},\\
       \textquotedbl\relax Degree\textquotedbl\relax: \{\textquotedbl\relax Educational program\textquotedbl\relax: \textquotedbl\relax\@programme\textquotedbl\relax\},\\
       \textquotedbl\relax Title\textquotedbl\relax: \{\\
            \hspace{1cm}\textquotedbl\relax Main title\textquotedbl\relax: \textquotedbl\relax\@title\textquotedbl\relax,\\
            \ifx\@subtitle\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax Subtitle\textquotedbl\relax: \textquotedbl\relax\@subtitle\textquotedbl\relax,\\
            \fi
        \ifinswedish
            \hspace{1cm}\textquotedbl\relax Language\textquotedbl\relax: \textquotedbl\relax swe\textquotedbl\relax
        \else
            \hspace{1cm}\textquotedbl\relax Language\textquotedbl\relax: \textquotedbl\relax eng\textquotedbl\relax
        \fi
       \},\\
    \textquotedbl\relax Alternative title\textquotedbl\relax: \{\\
	\hspace{1cm}\textquotedbl\relax Main title\textquotedbl\relax: \textquotedbl\relax\@alttitle\textquotedbl\relax,\\
        \ifx\@altsubtitle\@empty\relax
            \else
            \hspace{1cm}\textquotedbl\relax Subtitle\textquotedbl\relax: \textquotedbl\relax\@altsubtitle\textquotedbl\relax,\\
        \fi
        \ifinswedish
            \hspace{1cm}\textquotedbl\relax Language\textquotedbl\relax: \textquotedbl\relax eng\textquotedbl\relax\\
        \else
            \hspace{1cm}\textquotedbl\relax Language\textquotedbl\relax: \textquotedbl\relax swe\textquotedbl\relax\\
        \fi
    \},\\
    \textquotedbl\relax Other information\textquotedbl\relax: \{\\
      \hspace{1cm}\textquotedbl\relax Year\textquotedbl\relax: \textquotedbl\relax\@publicationYear\textquotedbl\relax,\\
      \hspace{1cm}\textquotedbl\relax Number of pages\textquotedbl\relax: \textquotedbl\relax\pageref{#1},\pageref{#2}\textquotedbl\relax
    \},\\
    \ifx\@supervisorAsLastname\@empty\relax
        \else
   \textquotedbl\relax Supervisor1\textquotedbl\relax: \{\\
            \hspace{1.5cm}\textquotedbl\relax Last name\textquotedbl\relax: \textquotedbl\relax\@supervisorAsLastname\textquotedbl\relax,\\
        \ifx\@supervisorAsFirstname\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax First name\textquotedbl\relax: \textquotedbl\relax\@supervisorAsFirstname\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorAsKTHID\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax Local User Id\textquotedbl\relax: \textquotedbl\relax\@supervisorAsKTHID\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorAsEmail\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax E-mail\textquotedbl\relax: \textquotedbl\relax\@supervisorAsEmail\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorAsOrganization\@empty
            \ifx\@supervisorAsSchool\@empty\relax
                \else
                \hspace{1.5cm}\textquotedbl\relax organisation\textquotedbl\relax: \{\textquotedbl\relax L1\textquotedbl\relax: \textquotedbl\relax\@supervisorAsSchool\textquotedbl\relax,\\
                \ifx\@supervisorAsDepartment\@empty\relax
                \else
                \hspace{2.75cm}\textquotedbl\relax L2\textquotedbl\relax: \textquotedbl\relax\@supervisorAsDepartment\textquotedbl\relax
                \fi
		    	\}\\
		    \fi
            \else
            \hspace{1.5cm}\textquotedbl\relax Other organisation\textquotedbl\relax: \textquotedbl\relax\@supervisorAsOrganization\textquotedbl\relax\}\\
        \fi
       \hspace{1.2cm}\},\\
    \fi
    \ifx\@supervisorBsLastname\@empty\relax
        \else
    \textquotedbl\relax Supervisor2\textquotedbl\relax: \{\\
            \hspace{1.5cm}\textquotedbl\relax Last name\textquotedbl\relax: \textquotedbl\relax\@supervisorBsLastname\textquotedbl\relax,\\
        \ifx\@supervisorBsFirstname\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax First name\textquotedbl\relax: \textquotedbl\relax\@supervisorBsFirstname\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorBsKTHID\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax Local User Id: \textquotedbl\relax\@supervisorBsKTHID\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorBsEmail\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax E-mail\textquotedbl\relax: \textquotedbl\relax\@supervisorBsEmail\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorBsOrganization\@empty
            \ifx\@supervisorBsSchool\@empty\relax
                \else
                \hspace{1.5cm}\textquotedbl\relax organisation\textquotedbl\relax: \{\textquotedbl\relax L1\textquotedbl\relax: \textquotedbl\relax\@supervisorBsSchool\textquotedbl\relax,\\
                \ifx\@supervisorBsDepartment\@empty\relax
                \else
                \hspace{2.75cm}\textquotedbl\relax L2\textquotedbl\relax: \textquotedbl\relax\@supervisorBsDepartment\textquotedbl\relax
                \fi
		    	\}\\
		    \fi
            \else
            \hspace{1.5cm}\textquotedbl\relax Other organisation\textquotedbl\relax: \textquotedbl\relax\@supervisorBsOrganization\textquotedbl\relax\\
        \fi
       \hspace{1.2cm}\},\\
    \fi
    \ifx\@supervisorBsLastname\@empty\relax
        \else
    \textquotedbl\relax Supervisor2\textquotedbl\relax: \{\\
            \hspace{1.5cm}\textquotedbl\relax Last name\textquotedbl\relax: \textquotedbl\relax\@supervisorBsLastname\textquotedbl\relax,\\
        \ifx\@supervisorBsFirstname\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax First name\textquotedbl\relax: \textquotedbl\relax\@supervisorBsFirstname\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorBsKTHID\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax Local User Id: \textquotedbl\relax\@supervisorBsKTHID\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorBsEmail\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax E-mail\textquotedbl\relax: \textquotedbl\relax\@supervisorBsEmail\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorBsOrganization\@empty
            \ifx\@supervisorBsSchool\@empty\relax
                \else
                \hspace{1.5cm}\textquotedbl\relax organisation\textquotedbl\relax: \{\textquotedbl\relax L1\textquotedbl\relax: \textquotedbl\relax\@supervisorBsSchool\textquotedbl\relax,\\
                \ifx\@supervisorBsDepartment\@empty\relax
                \else
                \hspace{2.75cm}\textquotedbl\relax L2\textquotedbl\relax: \textquotedbl\relax\@supervisorBsDepartment\textquotedbl\relax
                \fi
		    	\}\\
		    \fi
            \else
            \hspace{1.5cm}\textquotedbl\relax Other organisation\textquotedbl\relax: \textquotedbl\relax\@supervisorBsOrganization\textquotedbl\relax\\
        \fi
       \hspace{1.2cm}\},\\
    \fi
    \ifx\@supervisorCsLastname\@empty\relax
        \else
    \textquotedbl\relax Supervisor3\textquotedbl\relax: \{\\
            \hspace{1.5cm}\textquotedbl\relax Last name\textquotedbl\relax: \textquotedbl\relax\@supervisorCsLastname\textquotedbl\relax,\\
        \ifx\@supervisorCsFirstname\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax First name\textquotedbl\relax: \textquotedbl\relax\@supervisorCsFirstname\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorCsKTHID\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax Local User Id: \textquotedbl\relax\@supervisorCsKTHID\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorCsEmail\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax E-mail\textquotedbl\relax: \textquotedbl\relax\@supervisorCsEmail\textquotedbl\relax,\\
        \fi
        \ifx\@supervisorCsOrganization\@empty
            \ifx\@supervisorCsSchool\@empty\relax
                \else
                \hspace{1.5cm}\textquotedbl\relax organisation\textquotedbl\relax: \{\textquotedbl\relax L1\textquotedbl\relax: \textquotedbl\relax\@supervisorCsSchool\textquotedbl\relax,\\
                \ifx\@supervisorCsDepartment\@empty\relax
                \else
                \hspace{2.75cm}\textquotedbl\relax L2\textquotedbl\relax: \textquotedbl\relax\@supervisorCsDepartment\textquotedbl\relax
                \fi
		    	\}\\
		    \fi
            \else
            \hspace{1.5cm}\textquotedbl\relax Other organisation\textquotedbl\relax: \textquotedbl\relax\@supervisorCsOrganization\textquotedbl\relax\\
        \fi
       \hspace{1.2cm}\},\\
    \fi

    \ifx\@opponentsLastname\@empty\relax
        \else
    \textquotedbl\relax Opponent\textquotedbl\relax: \{\\
            \hspace{1.5cm}\textquotedbl\relax Last name\textquotedbl\relax: \textquotedbl\relax\@opponentsLastname\textquotedbl\relax,\\
        \ifx\@opponentsFirstname\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax First name\textquotedbl\relax: \textquotedbl\relax\@opponentsFirstname\textquotedbl\relax,\\
        \fi
        \ifx\@opponentsEmail\@empty\relax
            \else
            \hspace{1.5cm}\textquotedbl\relax E-mail\textquotedbl\relax: \textquotedbl\relax\@opponentsEmail\textquotedbl\relax,\\
        \fi
        \ifx\@opponentsOrganization\@empty
            \ifx\@opponentsSchool\@empty\relax
                \else
                \hspace{1.5cm}\textquotedbl\relax organisation\textquotedbl\relax: \{\textquotedbl\relax L1\textquotedbl\relax: \textquotedbl\relax\@opponentsSchool\textquotedbl\relax,\\
                \ifx\@opponentsDepartment\@empty\relax
                    \else
                    \hspace{2.75cm}\textquotedbl\relax L2\textquotedbl\relax: \textquotedbl\relax\@opponentsDepartment\textquotedbl\relax
                	\}\\
                    \fi
		    \fi
            \else
            \hspace{1.5cm}\textquotedbl\relax Other organisation\textquotedbl\relax: \textquotedbl\relax\@opponentsOrganization\textquotedbl\relax\\
        \fi
       \hspace{1.2cm}\},\\
       \fi
        \ifx\@presentationDateAndTimeISO\@empty\relax
        \else
       \textquotedbl\relax Presentation\textquotedbl\relax: \{ \\
        \hspace{1.5cm}\textquotedbl\relax Date\textquotedbl\relax: \textquotedbl\relax\@presentationDateAndTimeISO\textquotedbl\relax\\
        \ifx\@presentationLanguage\@empty\relax
        \else
            \hspace{1.5cm},\textquotedbl\relax Language\textquotedbl\relax: \textquotedbl\relax\@presentationLanguage\textquotedbl\relax\\
        \fi
        \ifx\@presentationRoom\@empty\relax
        \else
            \hspace{1.5cm},\textquotedbl\relax Room\textquotedbl\relax: \textquotedbl\relax\@presentationRoom\textquotedbl\relax\\
        \fi
        \ifx\@presentationAddress\@empty\relax
        \else
            \hspace{1.5cm},\textquotedbl\relax Address\textquotedbl\relax: \textquotedbl\relax\@presentationAddress\textquotedbl\relax\\
        \fi
        \ifx\@presentationCity\@empty\relax
        \else
            \hspace{1.5cm},\textquotedbl\relax City\textquotedbl\relax: \textquotedbl\relax\@presentationCity\textquotedbl\relax\\
        \fi
        \hspace{1.2cm}\},\\
    \fi
    \ifx\@nationalsubjectcategories\@empty\relax
        \else
        \textquotedbl\relax National Subject Categories\textquotedbl\relax: \textquotedbl\relax\@nationalsubjectcategories\textquotedbl\relax,\\
    \fi
    "Number of lang instances": \textquotedbl\relax\countsc{lang}\textquotedbl\relax,\\
    \foreach \i in {1,...,\countsc{lang}} {
      "Abstract[\getstored[\i]{lang}]": €€€€\\
      %\getstored[\i]{abstracts}
      \typestoredx{\i}{abstracts}
      €€€€,\\
      "Keywords[\getstored[\i]{lang}]": €€€€\\
      \getstored[\i]{keywords}
      €€€€,\\
    }
   \}
   \end{flushleft}
\clearpage
}

% Due to parsing problems with Overleaf's checking for balance of
% start and ends of beginning and ending use of "otherlanguage" and
% because babel and polyglossia & biblatex use different names for Norsk and German
% the following new commands have been added

\ifxeorlua
    \newcommand{\babelpolyLangStop}[1]{\end{#1}}
\else
    \newcommand{\babelpolyLangStop}[1]{\end{otherlanguage}}
\fi

\ifxeorlua
   \newcommand{\babelpolyLangStart}[1]{\begin{#1}}
\else
    \newcommand{\babelpolyLangStart}[1]{\begin{otherlanguage}{#1}}
\fi


\endinput
