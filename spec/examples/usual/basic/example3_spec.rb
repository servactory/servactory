# frozen_string_literal: true

RSpec.describe Usual::Basic::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { nil }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John <unknown> Kennedy")
        end
      end
    end

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect(perform).to have_service_input(:first_name).type(String).required
        expect(perform).to have_service_input(:middle_name).type(String).optional.default("<unknown>")
        expect(perform).to have_service_input(:last_name).type(String).required
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { nil }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John <unknown> Kennedy")
        end
      end
    end

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect(perform).to have_service_input(:first_name).type(String).required
        expect(perform).to have_service_input(:middle_name).type(String).optional.default("<unknown>")
        expect(perform).to have_service_input(:last_name).type(String).required
      end
    end
  end
end
