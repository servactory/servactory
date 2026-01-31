# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[result]

    describe "validations" do
      describe "outputs" do
        it "defines output :result but service fails before producing it" do
          expect(described_class.info.outputs.keys).to include(:result)
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:validation)
            expect(exception.message).to eq("Email is invalid")
            expect(exception.meta).to eq(field: :email)
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
                    outputs: %i[result]

    describe "but the data required for work is invalid" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result.success?).to be(false)
        expect(result.failure?).to be(true)
        expect(result.failure?(:validation)).to be(true)
        expect(result.error.type).to eq(:validation)
        expect(result.error.message).to eq("Email is invalid")
      end

      describe "pattern matching" do
        it "includes :error key for failures via deconstruct_keys(nil)", :aggregate_failures do
          result = perform
          keys = result.deconstruct_keys(nil)

          expect(keys).to have_key(:error)
          expect(keys[:error]).to be_a(ApplicationService::Exceptions::Failure)
          expect(keys[:success]).to be(false)
          expect(keys[:failure]).to be(true)
        end

        it "supports nested error pattern matching", :aggregate_failures do
          result = perform

          matched = case result
                    in { failure: true, error: { type: :validation, message:, meta: } }
                      { msg: message, data: meta }
                    else
                      nil
                    end

          expect(matched).to eq(msg: "Email is invalid", data: { field: :email })
        end

        it "supports Failure#deconstruct_keys for error object" do
          result = perform
          error_keys = result.error.deconstruct_keys(nil)

          expect(error_keys).to eq(
            type: :validation,
            message: "Email is invalid",
            meta: { field: :email }
          )
        end
      end
    end
  end
end
