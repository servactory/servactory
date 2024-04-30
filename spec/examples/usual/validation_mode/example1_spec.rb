# frozen_string_literal: true

RSpec.describe Usual::ValidationMode::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number: number
      }
    end

    let(:number) { 6 }

    include_examples "check class info",
                     inputs: %i[number],
                     internals: %i[number],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          expect(perform.error).to be_a(ApplicationService::Exceptions::Internal)
          expect(perform.error).to an_object_having_attributes(
            message: "[Usual::ValidationMode::Example1] Wrong type of internal attribute `number`, " \
                     "expected `Integer`, got `String`",
            meta: nil
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:number).valid_with(attributes).type(Integer).required }
    end
  end
end
