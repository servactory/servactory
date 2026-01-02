# frozen_string_literal: true

RSpec.describe Usual::Stage::Example12, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "outputs" do
        it "defines output :number but service always rolls back before producing it" do
          expect(described_class.info.outputs.keys).to include(:number)
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:base)
            expect(exception.message).to eq("rollback with bad number")
            expect(exception.meta).to be_nil
          end
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "outputs" do
        it "defines output :number but service always rolls back before producing it" do
          expect(described_class.info.outputs.keys).to include(:number)
        end
      end
    end

    describe "but the data required for work is invalid" do
      it_behaves_like "failure result class"

      it "returns the expected value in `errors`", :aggregate_failures do
        result = perform

        expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
        expect(result.error).to an_object_having_attributes(
          type: :base,
          message: "rollback with bad number",
          meta: nil
        )
      end
    end
  end
end
