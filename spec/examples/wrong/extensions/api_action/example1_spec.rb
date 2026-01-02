# frozen_string_literal: true

RSpec.describe Wrong::Extensions::ApiAction::Example1, type: :service do
  let(:http_client) { described_class::LikeAnHttpClient }

  before do
    http_client.reset!
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[response],
                    outputs: %i[user_data]

    describe "but the data required for work is invalid" do
      describe "because API request fails" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:api_error)
              expect(exception.message).to eq("API request failed for /users/42")
              expect(exception.meta).to be_nil
            end
          )
          expect(http_client.request_count).to eq(1)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 42 }

    describe "but the data required for work is invalid" do
      describe "because API request fails" do
        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :api_error,
            message: "API request failed for /users/42",
            meta: nil
          )
          expect(http_client.request_count).to eq(1)
        end
      end
    end
  end
end
