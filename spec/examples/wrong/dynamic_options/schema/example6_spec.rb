# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example6, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[payload],
                    outputs: %i[]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true }
                  }
                }
              )
              .message(be_a(Proc))
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "Problem with the value in the `payload` schema: `last_name` has `NilClass` instead of `String`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[payload],
                    outputs: %i[]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true }
                  }
                }
              )
              .message(be_a(Proc))
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "Problem with the value in the `payload` schema: `last_name` has `NilClass` instead of `String`"
          )
        )
      end
    end
  end
end
