# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example9, type: :service do
  let(:attributes) do
    {
      payload:
    }
  end

  let(:payload) do
    {
      issued_on: DateTime.new(2023, 1, 1)
    }
  end

  it_behaves_like "check class info",
                  inputs: %i[payload],
                  internals: %i[],
                  outputs: %i[issued_on]

  describe "validation" do
    describe "inputs" do
      it do
        expect { perform }.to(
          have_input(:payload)
            .valid_with(attributes)
            .type(Hash)
            .schema(
              {
                issued_on: {
                  type: [Date, DateTime, Time],
                  required: true,
                  prepare: be_a(Proc)
                }
              }
            )
            .required
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it { expect(perform).to have_output(:issued_on).contains("2023-01-01") }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it { expect(perform).to have_output(:issued_on).contains("2023-01-01") }
    end
  end
end
