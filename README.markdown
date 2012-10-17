Title: R Notebook

# R Notebook #

The R Notebook is a plugin for the octopress (<http://octopress.org>)
blogging system as well as stylesheets and scripts to support a
notebook-style of interacting with R to help with report generation and
reproducable research.  The idea is that text and layout is
handled by multimarkdown (<http://fletcherpenney.net/multimarkdown/>) while 
computation is handled by R.  The scripts use the knitr package
(<http://yihui.name/knitr/>) to process the embedded R code.

The `knit_markdown.R` script can be called independently as one can
pipe a source file using stdin and stdout redirection, for example,
for viewing in an external previewer such as Marked (<http://markedapp.com/>).

## Installation ##

1. Make your own clone of this repository
2. Install R from CRAN (<http://cran.r-project.org/>)
3. Follow the octopress setup instructions at <http://octopress.org/docs/setup/>
5. Run `rake preview` to start the octopress preview server
6. Make sure the demo page looks ok at 
   <http://localhost:4000/blog/2012/07/20/demo-page/>.
7. Enjoy!

## TODOs ##

* Collapsable code panels
* Interactively change plots
* Interactively add code directly on page

