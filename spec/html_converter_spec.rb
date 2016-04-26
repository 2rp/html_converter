require 'spec_helper'
require 'nokogiri'

module HtmlConverter
  describe Converter do
    subject { Converter.new(html) }

    describe '#to_text' do
      let(:html) { '<p>a <strong>b</strong></p>' }

      it 'converts' do
        expect(subject.to_text).to eq('a b')
      end
    end

    describe '#to_html_blocks' do
      let(:html) { '<p>a</p><p>b <strong>c</strong></p>' }

      it 'converts' do
        expect(subject.to_html_blocks).to eq(['a', '', 'b <strong>c</strong>'])
      end
    end
  end
end

