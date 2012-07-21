#!/usr/bin/Rscript

library(knitr)

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
  filename <- paste(x, collapse = '.')
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
    #sprintf('![plot of chunk %s](%s%s) ', 
            #options$label, base, filename)
    sprintf('![plot of chunk %s](%s%s?%d) ', 
            options$label, base, filename, pic.sample())
  }
}

# hack render_markdown so it doesn't override my custom hook
render_custom <- function() {
  render_markdown(strict=TRUE)
  knit_hooks$set(plot=query_plot_hook)
}

# need to read everything through stdin and stdout
pat_html()
render_custom()
opts_knit$set(progress=FALSE)
#opts_knit$set(dev='png')
opts_knit$set(out.format='custom')
opts_knit$set(input.dir=getwd())
knit(file("stdin"), stdout())


