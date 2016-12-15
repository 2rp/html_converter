module HtmlConverter
  class ToHtmlBlocks
    attr_reader :html, :clean_html
    def initialize(html)
      @html = (html || '').dup
      @clean_html = clean(@html.dup)
    end

    def convert
      return [] if self.clean_html.empty?
      return [self.clean_html] if nodes.empty?
      nodes.each_with_index.inject([]) do |out, (node, index)|
        out += extract_inner_html(node)
        out << '' if ['p', 'ul', 'ol'].include?(node.name) && nodes.size > index+1
        out
      end
    end

private

    def nodes
      doc = Nokogiri::HTML.fragment(self.clean_html)
      if missing_wrapper?(doc)
        Nokogiri::HTML.fragment("<div>#{self.clean_html}</div>").children
      else
        doc.children
      end
    end

    def extract_inner_html(node)
      case node.name
      when 'ul'
        extract_list_items(node.children) { |counter| '-' }
      when 'ol'
        extract_list_items(node.children) { |counter| "#{counter}."}
      else
        value = node.inner_html
        value = !value.nil? && !value.empty? ? value : node.text
        split_by_soft_break(value)
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

    def missing_wrapper?(doc)
      first_node = doc.children.first
      first_node && ['text', 'strong', 'em', 'i', 'b'].include?(first_node.name)
    end

    def clean(html)
      html.to_s.gsub(/[\r\n]/, "").strip
    end

  end
end
