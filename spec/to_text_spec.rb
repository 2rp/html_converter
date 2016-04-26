require 'spec_helper'
require 'nokogiri'

module HtmlConverter
  describe ToText do
    subject { ToText.new(input) }

    describe '#convert' do
      context "when '<p>a</p><p>b</p>'" do
        let(:input) { '<p>a</p><p>b</p>' }
        it "returns 'a b'" do
          expect(subject.convert).to eq('a b')
        end
      end
    end
  end
end
