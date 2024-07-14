# frozen_string_literal: true

RSpec.describe Usual::Description::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        id:
      }
    end

    let(:id) { "61d74de0-7b70-4f80-aefd-d86005d859ed" }

    include_examples "check class info",
                     inputs: %i[id],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:id)
            .valid_with(attributes)
            .type(String)
            .required
            .note("Payment identifier in an external system")
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        id:
      }
    end

    let(:id) { "61d74de0-7b70-4f80-aefd-d86005d859ed" }

    include_examples "check class info",
                     inputs: %i[id],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:id)
            .valid_with(attributes)
            .type(String)
            .required
            .note("Payment identifier in an external system")
        )
      end
    end
  end
end
