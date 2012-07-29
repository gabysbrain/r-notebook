
require 'tempfile'

module Jekyll

  require_relative 'post_filters'

  # A filter to pass mmd files through knitr
  class KnitrPost < PostFilter

    KNITR_PATH = File.join(File.dirname(__FILE__), "knit_markdown.R")

    unless File.exists?(KNITR_PATH) and File.executable?(KNITR_PATH)
      throw "knit_markdown.R is not found and executable"
    end

    def pre_render(post)
      if post.is_post?
        if post.ext == '.multimarkdown'
          postname = post.name[0..-post.ext.length-1]
          post.content = knit(postname, post.content)
        end
      end
    end
    
    # runs everything through knitr
    def knit(name, content)
      #knit_content, status = Open3.capture2(KNITR_PATH, name, 
                                            #:stdin_data=>content)
      # set up the tempfiles to do the translation
      src_file = Tempfile.new('srcfile')
      src_file.write(content)
      src_file.close
      dst_file = Tempfile.new('dstfile')
      dst_file.close

      # execute!
      `#{KNITR_PATH} #{name} #{src_file.path} #{dst_file.path}`

      # read back in the processed file
      dst_file.open
      knit_content = dst_file.read
      dst_file.close

      # remove the files
      src_file.unlink
      dst_file.unlink

      # This is a hack to get the double backslashes in latex math 
      # working with liquid templates
      knit_content.gsub(/\\\\$/){"\\\\\\\\"}
    end
  end
end

