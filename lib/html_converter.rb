require "html_converter/version"
require 'html_converter/to_text'
require 'html_converter/to_html_blocks'

module HtmlConverter
  class Converter
    attr_reader :html
    def initialize(html)
      @html = html
    end

    def to_text
      ToText.new(self.html).convert
    end

    def to_html_blocks
      ToHtmlBlocks.new(self.html).convert
    end
  end
end
