# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example11, type: :service do
  it_behaves_like "check class info",
                  inputs: %i[],
                  internals: %i[],
                  outputs: %i[payload issued_on]

  describe ".call!" do
    subject(:perform) { described_class.call! }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:payload)
            .contains(
              {
                issued_on: "2023-01-01"
              }
            )
        )
      end

      it { expect(perform).to have_output(:issued_on).contains("2023-01-01") }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:payload)
            .contains(
              {
                issued_on: "2023-01-01"
              }
            )
        )
      end

      it { expect(perform).to have_output(:issued_on).contains("2023-01-01") }
    end
  end
end
