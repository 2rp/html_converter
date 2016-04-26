module HtmlConverter
  class ToHtmlBlocks
    attr_reader :html
    def initialize(html)
      @html = html
    end

    def convert
      out = []
      nodes.each_with_index do |node, index|
        out += extract_inner_html(node)
        out << '' if ['p'].include?(node.name) && nodes.size > index+1
      end
      out
    end

private

    def nodes
      doc = Nokogiri::HTML.fragment(self.html)
      if ['text', 'strong', 'em', 'i', 'b'].include?(doc.children.first.name)
        Nokogiri::HTML.fragment("<div>#{self.html}</div>").children
      else
        doc.children
      end
    end

    def extract_inner_html(node)
      case node.name
      when 'ul'
        node.children.map {|n| "* #{clean(n.inner_html)}"}
      when 'ol'
        index = 0
        node.children.map {|n| "#{index+=1}. #{clean(n.inner_html)}"}
      else
        [*split_by_soft_break(node.inner_html)]
      end
    end

    def split_by_soft_break(html)
      html.split(/<\s*[b][r]\s*\/*>/).map { |h| clean(h) }
    end

    def clean(html)
      html.tap do |out|
        out.gsub!(/\r/, "")
        out.gsub!(/\n/, "")
        out.strip!
      end
    end
  end
end
