# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Authorization::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_role:
      }
    end

    let(:user_role) { "guest" }

    it_behaves_like "check class info",
                    inputs: %i[user_role],
                    internals: %i[],
                    outputs: %i[message]

    describe "but the data required for work is invalid" do
      describe "because user is not authorized" do
        it_behaves_like "failure result class"

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:unauthorized)
              expect(exception.message).to eq("Not authorized to perform this action")
              expect(exception.meta).to be_nil
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_role:
      }
    end

    let(:user_role) { "guest" }

    describe "but the data required for work is invalid" do
      describe "because user is not authorized" do
        it_behaves_like "failure result class"

        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :unauthorized,
            message: "Not authorized to perform this action",
            meta: nil
          )
        end
      end
    end
  end
end
