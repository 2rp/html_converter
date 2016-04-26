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
        out << '' if ['p', 'ul', 'ol'].include?(node.name) && nodes.size > index+1
      end
      out
    end

private

    def nodes
      clean_html = clean(self.html)
      return [] if clean_html.empty?
      doc = Nokogiri::HTML.fragment(clean_html)
      if ['text', 'strong', 'em', 'i', 'b'].include?(doc.children.first.name)
        Nokogiri::HTML.fragment("<div>#{clean_html}</div>").children
      else
        doc.children
      end
    end

    def extract_inner_html(node)
      case node.name
      when 'ul'
        extract_list_items(node.children) { |counter| '*' }
      when 'ol'
        extract_list_items(node.children) { |counter| "#{counter}."}
      else
        split_by_soft_break(node.inner_html)
      end
    end

    def extract_list_items(children)
      counter = 0
      children.inject([]) do |out, child|
        list_symbol = yield(counter+=1)
        items = split_by_soft_break(child.inner_html)
        out << "#{list_symbol} #{items.first}" unless items.empty?
        out += items[1..-1] if items.size > 1
        out
      end
    end

    def split_by_soft_break(html)
      html.split(/<\s*[b][r]\s*\/*>/).map { |h| clean(h) }
    end

    def clean(html)
      return '' if html.nil?
      html.tap do |out|
        out.gsub!(/\r/, "")
        out.gsub!(/\n/, "")
        out.strip!
      end
    end

  end
end
