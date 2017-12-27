require "spec_helper.rb"

describe Wordz::Generator do
  describe "#generate" do
    let(:subjects) { {} }
    let(:output) do
      described_class.new(grammar, subjects: subjects).generate
    end
    let(:prob_threshold) { 0 }
    before(:each) { fix_rand(prob_threshold) }

    context "when the grammar contains a plain string literal" do
      let(:grammar) { { "<root>" => [["foo"]] } }

      it "generates that literal string" do
        expect(output).to eq("foo")
      end

      context "with a probability" do
        let(:grammar) { { "<root>" => [["foo|0.5"]] } }

        context "if the probability condition is met" do
          let(:prob_threshold) { 0.3 }

          it "produces the string" do
            expect(output).to eq("foo")
          end
        end

        context "if the probability condition is not met" do
          let(:prob_threshold) { 0.7 }

          it "produces a blank string" do
            expect(output).to eq("")
          end
        end
      end
    end

    context "when the grammar contains a method instruction" do
      let(:grammar) { { "<root>" => [["#dog#quality#"]] } }

      context "when the receiver matches a declared subject" do
        let(:dog) { double("Dog", quality: "cute") }
        let(:subjects) { { dog: dog } }

        it "calls the method on the receiver" do
          expect(output).to eq(dog.quality)
        end

        context "with a probability" do
          let(:grammar) { { "<root>" => [["#dog#quality#|0.5"]] } }

          context "if the probability condition is met" do
            let(:prob_threshold) { 0.3 }

            it "produces the string" do
              expect(output).to eq(dog.quality)
            end
          end

          context "if the probability condition is not met" do
            let(:prob_threshold) { 0.7 }

            it "produces a blank string" do
              expect(output).to eq("")
            end
          end
        end
      end

      context "when the receiver does not match a declared subject" do
        it "raises an error" do
          expect { output }.to raise_error(
            described_class::UndefinedReceiverError,
          )
        end
      end
    end

    context "when the grammar contains a macro instruction" do
      context "when the macro matches a grammar key" do
        let(:grammar) do
          { "<root>" => [["<color>"]],
            "<color>" => [["brown"]] }
        end

        it "drills down into the specified macro" do
          expect(output).to eq("brown")
        end

        context "with a probability" do
          let(:grammar) do
            { "<root>" => [["The dog is", "<color>|0.5", "."]],
              "<color>" => [["brown"]] }
          end

          context "if the probability condition is met" do
            let(:prob_threshold) { 0.3 }

            it "produces the string" do
              expect(output).to eq("The dog is brown.")
            end
          end

          context "if the probability condition is not met" do
            let(:prob_threshold) { 0.7 }

            it "produces a blank string" do
              expect(output).to eq("The dog is.")
            end
          end
        end
      end

      context "when the macro doesn't match a grammar key" do
        let(:grammar) { { "<root>" => [["<color>"]] } }

        it "raises an error" do
          expect { output }.to raise_error(
            described_class::UndefinedMacroError,
          )
        end
      end
    end

    context "with a custom root node" do
      let(:grammar) do
        { "<root>" => [["foo"]],
          "<custom>" => [["bar"]] }
      end

      let(:output_from_custom_node) do
        described_class.new(grammar, subjects: subjects).generate("<custom>")
      end

      it "starts evaluation at that node" do
        expect(output_from_custom_node).to eq("bar")
      end
    end

    context "with a complex grammar" do
      let(:grammar) do
        { "<root>" => [["A", "<color>", "dog is", "#dog#quality#"]],
          "<color>" => [["brown"]] }
      end
      let(:subjects) { { dog: double("Dog", quality: "cute") } }

      it "it combines the various components" do
        expect(output).to eq("A brown dog is cute")
      end
    end

    context "with sentence terminators" do
      let(:grammar) { { "<root>" => [["Hi", "!"]] } }
      it "doesn't add a space before the terminator" do
        expect(output).to eq("Hi!")
      end
    end

    context "with an indefinite article" do
      let(:grammar) do
        { "<root>" => [["$INDEF_ARTICLE", next_instruction]] }
      end

      context "with and initial vowel" do
        let(:next_instruction) { "English Bulldog" }

        it "replaces the post-processed phrase with 'an'" do
          expect(output).to eq("an English Bulldog")
        end
      end

      context "with and initial consonant" do
        let(:next_instruction) { "dog" }

        it "replaces the post-processed phrase with 'a'" do
          expect(output).to eq("a dog")
        end
      end
    end

    def fix_rand(val)
      allow(Kernel).to receive(:rand).and_return(val)
    end
  end
end
