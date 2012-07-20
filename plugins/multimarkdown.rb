# multimarkdown renderer for jekyll
#
# from: https://github.com/danieldriver/jekyll/commit/a07766e3c5cb1c78b7b77643f850a67cb721763a


module Jekyll
  require 'multimarkdown'
  class MultimarkdownConverter < Converter
    safe false
    priority :low

    def matches(ext)
      ext =~ /multimarkdown/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      MultiMarkdown.new(content).to_html
    end
  end
end

