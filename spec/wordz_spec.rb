require "spec_helper"

RSpec.describe Wordz do
  it "has a version number" do
    expect(Wordz::VERSION).not_to be nil
  end

  describe ".generate" do
    let(:generator) { double("Generator", call: "") }

    before(:each) do
      allow(Wordz::Generator).to receive(:new).and_return(generator)
    end

    context "with all parameters specified" do
      let(:grammar) { { "<foo>" => [["Hello world."]] } }
      let(:subjects) { { dog: double("Dog") } }
      let(:root) { "<foo>" }

      it "constructs a generator and calls it" do
        described_class.generate(
          grammar: grammar,
          subjects: subjects,
          root: root,
        )

        expect(Wordz::Generator).to have_received(:new).with(
          grammar: grammar,
          subjects: subjects,
        )

        expect(generator).to have_received(:call).with(root)
      end
    end

    context "with no parameters specified" do
      it "passes on the expected defaults to a generator" do
        described_class.generate

        expect(Wordz::Generator).to have_received(:new).with(
          grammar: {},
          subjects: {},
        )

        expect(generator).to have_received(:call).with(nil)
      end
    end
  end
end
