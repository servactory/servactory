# frozen_string_literal: true

RSpec.describe Wrong::Extensions::ExternalApiRequest::Example1, type: :service do
  let(:api_client) { described_class::LikeAnApiClient }

  before do
    api_client.reset!
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 99 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[api_response]

    describe "but the data required for work is invalid" do
      describe "because external API request fails" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:external_api_error)
              expect(exception.message).to eq("Connection failed for user 99")
              expect(exception.meta).to match(original_exception: be_a(described_class::LikeAFaradayError))
            end
          )
          expect(api_client.request_count).to eq(1)
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

    let(:user_id) { 99 }

    describe "but the data required for work is invalid" do
      describe "because external API request fails" do
        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error.type).to eq(:external_api_error)
          expect(result.error.message).to eq("Connection failed for user 99")
          expect(result.error.meta).to match(original_exception: be_a(described_class::LikeAFaradayError))
          expect(api_client.request_count).to eq(1)
        end
      end
    end
  end
end
