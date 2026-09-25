# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example6, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[success error]

    describe "but the data required for work is invalid" do
      it "returns expected error", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:validation)
            expect(exception.message).to eq("Email is invalid")
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
                    outputs: %i[success error]

    describe "but the data required for work is invalid" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result.success?).to be(false)
        expect(result.failure?(:validation)).to be(true)
        expect(result.error.message).to eq("Email is invalid")
      end

      describe "outputs named after state keys" do
        it "are present in to_h" do
          expect(perform.to_h).to eq(success: "Saved", error: "None")
        end

        it "do not override state keys in deconstruct_keys(nil)", :aggregate_failures do
          keys = perform.deconstruct_keys(nil)

          expect(keys.keys).to contain_exactly(:success, :failure, :error)
          expect(keys[:success]).to be(false)
          expect(keys[:failure]).to be(true)
          expect(keys[:error]).to be_a(ApplicationService::Exceptions::Failure)
        end

        it "do not override state keys in deconstruct_keys with requested keys", :aggregate_failures do
          keys = perform.deconstruct_keys(%i[success error])

          expect(keys.keys).to contain_exactly(:success, :error)
          expect(keys[:success]).to be(false)
          expect(keys[:error]).to be_a(ApplicationService::Exceptions::Failure)
        end

        it "match the failure state in a pattern" do
          matched = case perform
                    in { success: false, failure: true, error: { type: :validation, message: } }
                      message
                    else
                      :no_match
                    end

          expect(matched).to eq("Email is invalid")
        end
      end
    end
  end
end
