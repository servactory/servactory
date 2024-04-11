# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example1, type: :service do
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
      it "returns expected inputs", :aggregate_failures do
        expect(perform).to be_service_input(:input_1).type(String).required
        expect(perform).to be_service_input(:input_2).type(String).required
        expect(perform).to be_service_input(:input_3).type(String).required
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
      it "returns expected inputs", :aggregate_failures do
        expect(perform).to be_service_input(:input_1).type(String).required
        expect(perform).to be_service_input(:input_2).type(String).required
        expect(perform).to be_service_input(:input_3).type(String).required
      end
    end
  end
end
