require "spec_helper.rb"

describe Wordz::Instruction do
  describe "#macro?" do
    context "when the text has the form of a macro" do
      it "returns true" do
        [
          "<node>",
          "<node_with_probability>|0.9",
        ].each do |text|
          expect(described_class.new(text)).to be_macro
        end
      end
    end

    context "when the text does not have the form of a macro" do
      it "returns false" do
        [
          "",
          "<>",
          "<node",
          "node>",
          "<node>|",
          "<node>|9",
          "<node>|.9",
        ].each do |text|
          expect(described_class.new(text)).not_to be_macro
        end
      end
    end
  end

  describe "#method?" do
    context "when the text has the form of a method" do
      it "returns true" do
        [
          "#receiver#message#",
          "#receiver#message#|0.9",
        ].each do |text|
          word = described_class.new(text)
          expect(word).to be_method
        end
      end
    end

    context "when the text does not have the form of a method" do
      it "returns false" do
        [
          "",
          "###",
          "#receiver##",
          "##message#",
          "#receiver#message",
          "receiver$message#",
          "#receiver#message#|",
          "#receiver#message#|9",
          "#receiver#message#|.9",
        ].each do |text|
          word = described_class.new(text)
          expect(word).not_to be_method
        end
      end
    end
  end

  describe "#probability" do
    let(:word) { described_class.new(text) }
    let(:probability) { word.probability }

    context "when the text includes a probability" do
      let(:text) { "foo_bar|0.8" }

      it "returns that proabability as a float" do
        expect(probability).to eq(0.8)
      end
    end

    context "when the text does not include a probability" do
      let(:text) { "foo_bar" }

      it "returns 1 as a float" do
        expect(probability).to eq(1.0)
      end
    end
  end
end
