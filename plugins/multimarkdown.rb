# multimarkdown renderer for jekyll
#
# adapted from: https://github.com/danieldriver/jekyll/commit/a07766e3c5cb1c78b7b77643f850a67cb721763a


module Jekyll
  require 'multimarkdown'

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
      puts MultiMarkdown.new(content).to_html
      MultiMarkdown.new(knit(content)).to_html
    end

    # runs everything through knitr
    def knit(content)
      knit_content, status = Open3.capture2(KNITR_PATH, :stdin_data=>content)
      knit_content
    end
  end
end

