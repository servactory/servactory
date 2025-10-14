# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example10, type: :service do
  it_behaves_like "check class info",
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
                  required: true
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
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:issued_on)
            .contains(DateTime.new(2023, 1, 1))
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:issued_on)
            .contains(DateTime.new(2023, 1, 1))
        )
      end
    end
  end
end
