#!/usr/bin/Rscript

library(knitr)

args <- commandArgs(trailingOnly=TRUE)

# the file name generating this R code
# needed so we can put separate cache and image links
post.name <- args[1]
store.prefix <- if(is.na(post.name)) "" else post.name
cache.path <- paste('cache', store.prefix, "", sep='/')
image.save.path <- paste('source/images/knitr', store.prefix, "", sep='/')
image.load.path <- paste('/images/knitr', store.prefix, "", sep='/')
opts_chunk$set(cache.path=cache.path)
opts_chunk$set(fig.path=image.save.path)

# also get the input and output files
in.file <- if(is.na(args[2])) file("stdin") else args[2]
out.file <- if(is.na(args[3])) stdout() else args[3]

pic.sample <- function() {
  sample(1000,1)
}

# hook to force marked to reload output images
# uses a random query element on the image
# also supports creating animations
query_plot_hook <- function(x, options) {
  # pull out all the relevant plot options
  animate <- options$fig.show == 'animate'
  fig.num <- options$fig.num
  fig.cur <- options$fig.cur
  if(is.null(fig.cur)) fig.cur <- 0

  # Don't print out intermediate plots if we're animating
  if(animate && fig.cur < fig.num) return('')

  base <- opts_knit$get('base.url')
  if (is.null(base)) base <- ''
  # adjust the base for the base path
  filename <- paste(image.load.path, basename(paste(x,collapse='.')), sep='')
  if(options$fig.show == 'animate') {
    # set up the ffmpeg run
    ffmpeg.opts <- options$aniopts
    fig.fname <- paste(sub(paste(fig.num, '$',sep=''), '', x[1]), "%d.png", sep="")
    mov.fname <- paste(sub(paste(fig.num, '$',sep=''), '', x[1]), ".mp4", sep="")
    if(is.na(ffmpeg.opts)) ffmpeg.opts <- NULL

    ffmpeg.cmd <- paste("ffmpeg", "-y", "-r", 1/options$interval, 
                        "-i", fig.fname, mov.fname)
    system(ffmpeg.cmd, ignore.stdout=TRUE)

    # figure out the options for the movie itself
    mov.opts <- strsplit(options$aniopts, ';')[[1]]
    opt.str <- paste(
      " ",
      if(!is.null(options$out.width)) sprintf('width=%s', options$out.width),
      if(!is.null(options$out.height)) sprintf('height=%s', options$out.height),
      if('controls' %in% mov.opts) 'controls="controls"',
      if('loop' %in% mov.opts) 'loop="loop"')
    sprintf('<video %s><source src="%s?%d" type="video/mp4" />video of chunk %s</video>', opt.str, mov.fname, pic.sample(), options$label)
  } else {
    sprintf('![plot of chunk %s](%s%s?%d) ', 
            options$label, base, filename, pic.sample())
  }
}

# highlight R code on output
code_hook <- function(x, options) {
  print(options)
  prefix <- sprintf("\n\n{%% codeblock %s lang:r %%}", options$label)
  suffix <- "{% endcodeblock %}\n\n"
  paste(prefix, x, suffix, sep="\n")
}

# hack render_markdown so it doesn't override my custom hook
render_custom <- function() {
  render_markdown(strict=TRUE)
  knit_hooks$set(plot=query_plot_hook,
                 source=code_hook)
}

# need to read everything through stdin and stdout
pat_html()
render_custom()
opts_knit$set(progress=FALSE)
#opts_knit$set(dev='png')
opts_knit$set(out.format='custom')
opts_knit$set(input.dir=getwd())
knit(in.file, out.file)


