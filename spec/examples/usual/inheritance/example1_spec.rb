# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        input_1:,
        input_2:,
        input_3:
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

        it { expect(perform).to have_output(:output_1).contains("First") }
        it { expect(perform).to have_output(:output_2).contains("Second") }
        it { expect(perform).to have_output(:output_3).contains("Third") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:input_1).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:input_2).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:input_3).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        input_1:,
        input_2:,
        input_3:
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

        it { expect(perform).to have_output(:output_1).contains("First") }
        it { expect(perform).to have_output(:output_2).contains("Second") }
        it { expect(perform).to have_output(:output_3).contains("Third") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:input_1).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:input_2).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:input_3).valid_with(attributes).type(String).required }
    end
  end
end
