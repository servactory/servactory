# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::Matchers::NestedOutputService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[response]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:response)
              .instance_of(described_class::Response)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "traverses a single nested level" do
        expect(perform).to(
          have_output(:response)
            .nested(:data)
            .contains(described_class::ResponseData.new(items: [1, 2, 3], meta: { count: 3 }))
        )
      end

      it "traverses several nested levels to an array" do
        expect(perform).to(
          have_output(:response)
            .instance_of(described_class::Response)
            .nested(:data, :items)
            .contains([3, 2, 1])
        )
      end

      it "traverses several nested levels to a hash" do
        expect(perform).to(
          have_output(:response)
            .nested(:data, :meta)
            .contains(count: 3)
        )
      end

      it "fails when the value at the nested path differs", :aggregate_failures do
        matcher = have_output(:response).nested(:data, :meta).contains(count: 4)

        expect(matcher.matches?(perform)).to be(false)
        expect(matcher.failure_message).to include("to match")
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[response]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "traverses several nested levels to an array" do
        expect(perform).to(
          have_output(:response)
            .nested(:data, :items)
            .contains([1, 2, 3])
        )
      end

      it "traverses several nested levels to a hash" do
        expect(perform).to(
          have_output(:response)
            .nested(:data, :meta)
            .contains(count: 3)
        )
      end
    end
  end
end
