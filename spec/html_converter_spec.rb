require 'spec_helper'
require 'nokogiri'

module HtmlConverter
  describe Converter do
    subject { Converter.new(html) }

    describe '#to_text' do
      let(:html) { '<p>a <strong>b</strong></p>' }

      it 'converts html input to text' do
        expect(subject.to_text).to eq('a b')
      end
    end

    describe '#to_html_blocks' do
      let(:html) { '<p>a</p><p>b <strong>c</strong></p>' }

      it 'converts html input to blocks of html' do
        expect(subject.to_html_blocks).to eq(['a', '', 'b <strong>c</strong>'])
      end
    end

    describe '#convert_to' do
      let(:html) { '<p>a</p>' }
      let(:result) { subject.convert_to(format) }

      context "when format: :text" do
        let(:format) { :text }

        it 'converts html input to text' do
          expect(result).to eq('a')
        end
      end

      context "when format: :html_blocks" do
        let(:format) { :html_blocks }

        it 'converts html input to html blocks' do
          expect(result).to eq(['a'])
        end
      end

      context "when format is not recognized" do
        let(:format) { :unrecognized_format }

        it 'raises an error' do
          expect { result }.to raise_error("Couldn't recognize format: '#{format}'.")
        end
      end

      context "when format is blank" do
        let(:format) { nil }

        it 'raises an error' do
          expect { result }.to raise_error("Please specify a :format to use #convert.")
        end
      end
    end
  end
end
