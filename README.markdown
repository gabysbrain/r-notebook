Title: R Notebook

# R Notebook #

The R Notebook is a collection of scripts and stylesheets to support a
notebook-style of interacting with R to help with report generation and
reproducable research.  The idea is that text and layout is
handled by multimarkdown (<http://fletcherpenney.net/multimarkdown/>) while 
computation is handled by R.  The scripts use the knitr package
(<http://yihui.name/knitr/>) to process the embedded R code.

The scripts are designed to be used as a custom markdown processor for the
Marked multimarkdown preview application (<http://markedapp.com/>), but
there's nothing binding the scripts to this application.

## Main features ##

* script to read markdown code with embedded R 
* custom CSS for interactive stuff (coming soon)

## TODOs ##

* Collapsable code panels
* Interactively change plots
* Interactively add code directly on page

