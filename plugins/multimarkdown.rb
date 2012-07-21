# multimarkdown renderer for jekyll
#
# from: https://github.com/danieldriver/jekyll/commit/a07766e3c5cb1c78b7b77643f850a67cb721763a


module Jekyll
  require 'multimarkdown'
  require 'rinruby'

  class MultimarkdownConverter < Converter
    safe false
    priority :low

    KNITR_PATH = File.join(File.dirname(__FILE__), "knit_markdown.R")

    unless File.exists?(KNITR_PATH) and File.executable?(KNITR_PATH)
      throw "knit_markdown.R is not found and executable"
    end

    def matches(ext)
      ext =~ /multimarkdown/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      MultiMarkdown.new(knit(content)).to_html
    end

    # runs everything through knitr
    def knit(content)
      R.eval File.read(KNITR_PATH)
    end
  end
end

