# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        api_identifier: api_identifier,
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        date: date
      }
    end

    let(:api_identifier) { "First" }
    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:date) { DateTime.new(2023, 1, 1) }

    include_examples "check class info",
                     inputs: %i[api_identifier date first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[api_response]

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect(perform).to have_input(:api_identifier).type(String).required
        expect(perform).to have_input(:first_name).type(String).required
        expect(perform).to have_input(:middle_name).type(String).required
        expect(perform).to have_input(:last_name).type(String).required
        expect(perform).to have_input(:date).type(DateTime).required
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        api_identifier: api_identifier,
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        date: date
      }
    end

    let(:api_identifier) { "First" }
    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:date) { DateTime.new(2023, 1, 1) }

    include_examples "check class info",
                     inputs: %i[api_identifier date first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[api_response]

    context "when the input arguments are invalid" do
      it { expect(perform).to have_input(:api_identifier).type(String).required }
      it { expect(perform).to have_input(:first_name).type(String).required }
      it { expect(perform).to have_input(:middle_name).type(String).required }
      it { expect(perform).to have_input(:last_name).type(String).required }
      it { expect(perform).to have_input(:date).type(DateTime).required }
    end
  end
end
