# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example10, type: :service do
  include_examples "check class info",
                   inputs: %i[],
                   internals: %i[payload],
                   outputs: %i[issued_on]

  describe "validation" do
    describe "internals" do
      it do
        expect { perform }.to(
          have_internal(:payload)
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
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call! }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:issued_on).contains("2023-01-01") }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:issued_on).contains("2023-01-01") }
    end
  end
end
