# frozen_string_literal: true

RSpec.describe Wrong::Extensions::ExternalApiRequest::Example1, type: :service do
  let(:api_client) { described_class::LikeAnApiClient }
  let(:faraday_error_class) { described_class::LikeAFaradayError }

  before do
    api_client.reset!
    api_client.should_fail = true
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id
      }
    end

    let(:user_id) { 99 }

    context "when the API request raises a Faraday error" do
      it "raises an error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Failure,
            "Connection refused"
          )
        )
      end

      it "makes the API request" do
        expect { perform }.to raise_error(ApplicationService::Exceptions::Failure)

        expect(api_client.request_count).to eq(1)
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id: user_id
      }
    end

    let(:user_id) { 99 }

    context "when the API request raises a Faraday error" do
      it "returns failure result with meta containing original exception", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).not_to be_success
        expect(result).to be_failure
        expect(result.error.type).to eq(:base)
        expect(result.error.message).to eq("Connection refused")
        expect(result.error.meta[:original_exception]).to be_a(faraday_error_class)
      end

      it "makes the API request" do
        perform

        expect(api_client.request_count).to eq(1)
      end
    end
  end
end
