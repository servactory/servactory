# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example22 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        input_1: input_1,
        input_2: input_2,
        input_3: input_3
      }
    end

    let(:input_1) { "First" }
    let(:input_2) { "Second" }
    let(:input_3) { "Third" }

    include_examples "check class info",
                     inputs: %i[input_1 input_2 input_3],
                     internals: %i[],
                     outputs: %i[output_1 output_2 output_3]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`", :aggregate_failures do
          result = perform

          expect(result.output_1).to eq("First")
          expect(result.output_2).to eq("Second")
          expect(result.output_3).to eq("Third")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `input_1`" do
        it_behaves_like "input required check", name: :input_1
        it_behaves_like "input type check", name: :input_1, expected_type: String
      end

      context "when `input_2`" do
        it_behaves_like "input required check", name: :input_2
        it_behaves_like "input type check", name: :input_2, expected_type: String
      end

      context "when `input_3`" do
        it_behaves_like "input required check", name: :input_3
        it_behaves_like "input type check", name: :input_3, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        input_1: input_1,
        input_2: input_2,
        input_3: input_3
      }
    end

    let(:input_1) { "First" }
    let(:input_2) { "Second" }
    let(:input_3) { "Third" }

    include_examples "check class info",
                     inputs: %i[input_1 input_2 input_3],
                     internals: %i[],
                     outputs: %i[output_1 output_2 output_3]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`", :aggregate_failures do
          result = perform

          expect(result.output_1).to eq("First")
          expect(result.output_2).to eq("Second")
          expect(result.output_3).to eq("Third")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `input_1`" do
        it_behaves_like "input required check", name: :input_1
        it_behaves_like "input type check", name: :input_1, expected_type: String
      end

      context "when `input_2`" do
        it_behaves_like "input required check", name: :input_2
        it_behaves_like "input type check", name: :input_2, expected_type: String
      end

      context "when `input_3`" do
        it_behaves_like "input required check", name: :input_3
        it_behaves_like "input type check", name: :input_3, expected_type: String
      end
    end
  end
end
