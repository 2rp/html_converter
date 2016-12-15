module HtmlConverter
  class ToText
    attr_reader :html
    def initialize(html)
      @html = (html || '').dup
    end

    def convert
      doc = Nokogiri::HTML(@html)
      doc.xpath("//text()").map(&:text).join(" ").gsub('  ', ' ')
    end
  end
end
