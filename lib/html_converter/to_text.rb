module HtmlConverter
  class ToText
    attr_reader :html
    def initialize(html)
      @html = html
    end

    def convert
      doc = Nokogiri::HTML.fragment(@html)
      doc.text
    end
  end
end
