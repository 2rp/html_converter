require 'spec_helper'
require 'nokogiri'

module HtmlConverter
  describe ToHtmlBlocks do
    subject { ToHtmlBlocks.new(input) }

    describe '#convert' do
      context "when '<p>a</p><p>b</p>'" do
        let(:input) { '<p>a</p><p>b</p>' }
        it "returns ['a', '', 'b']" do
          expect(subject.convert).to eq(['a', '', 'b'])
        end
      end

      context "when '<p>a <strong>b</strong></p>'" do
        let(:input) { '<p>a <strong>b</strong></p>' }
        it "returns ['a <strong>b</strong>']" do
          expect(subject.convert).to eq(['a <strong>b</strong>'])
        end
      end

      context "when '<ul><li>a</li><li>b</li></ul>'" do
        let(:input) { '<ul><li>a</li><li>b</li></ul>' }
        it "returns ['* a', '* b']" do
          expect(subject.convert).to eq(['* a', '* b'])
        end
      end

      context "when '<ol><li>a</li><li>b</li></ol>'" do
        let(:input) { '<ol><li>a</li><li>b</li></ol>' }
        it "returns ['1. a', '2. b']" do
          expect(subject.convert).to eq(['1. a', '2. b'])
        end
      end

      context "when 'a'" do
        let(:input) { 'a' }
        it "returns ['a']" do
          expect(subject.convert).to eq(['a'])
        end
      end

      context "when 'a <strong>b</strong>'" do
        let(:input) { 'a <strong>b</strong>' }
        it "returns ['a <strong>b</strong>']" do
          expect(subject.convert).to eq(['a <strong>b</strong>'])
        end
      end

      context "when 'a <br> b'" do
        let(:input) { 'a <br> b' }
        it "returns ['a', 'b']" do
          expect(subject.convert).to eq(['a', 'b'])
        end
      end

      context "when 'a\\r\\nb'" do
        let(:input) { "a\r\nb" }
        it "returns ['ab']" do
          expect(subject.convert).to eq(['ab'])
        end
      end

      context "when 'a\\rb'" do
        let(:input) { "a\rb" }
        it "returns ['ab']" do
          expect(subject.convert).to eq(['ab'])
        end
      end

      context "when 'a\\nb'" do
        let(:input) { "a\nb" }
        it "returns ['ab']" do
          expect(subject.convert).to eq(['ab'])
        end
      end

      context "when '<ul>\\n<li>a<br>\\n</li>\\r\\n</ul>'" do
        let(:input) { "<ul>\n<li>a<br>\n</li>\r\n</ul>" }
        it "returns ['* a']" do
          expect(subject.convert).to eq(['* a'])
        end
      end

      context "when '<b>a<br></b>'" do
        let(:input) { "<b>a<br></b>" }
        it "returns ['<b>a', '</b>']" do
          expect(subject.convert).to eq(['<b>a', '</b>'])
        end
      end

      context "when '' (blank)" do
        let(:input) { "" }
        it "returns []" do
          expect(subject.convert).to eq([])
        end
      end

      context "when nil" do
        let(:input) { nil }
        it "returns []" do
          expect(subject.convert).to eq([])
        end
      end
    end
  end
end
