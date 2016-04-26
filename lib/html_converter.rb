require "html_converter/version"
require 'html_converter/to_text'
require 'html_converter/to_html_blocks'

module HtmlConverter

  CONVERTER = {
    text: ToText,
    html_blocks: ToHtmlBlocks
  }

  class Converter
    attr_reader :html

    def initialize(html)
      @html = html
    end

    def convert_to(format)
      format or raise "Please specify a :format to use #convert."
      converter = CONVERTER[format] or raise "Couldn't recognize format: '#{format}'."
      converter.new(self.html).convert
    end

    def to_text
      ToText.new(self.html).convert
    end

    def to_html_blocks
      ToHtmlBlocks.new(self.html).convert
    end
  end
end
