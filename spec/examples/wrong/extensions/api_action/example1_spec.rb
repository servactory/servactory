# frozen_string_literal: true

RSpec.describe Wrong::Extensions::ApiAction::Example1, type: :service do
  let(:http_client) { described_class::LikeAnHttpClient }

  before do
    http_client.reset!
    http_client.should_fail = true
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id
      }
    end

    let(:user_id) { 1 }

    context "when the API request fails" do
      it "raises an error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Failure,
            "Request failed"
          )
        )
      end

      it "makes the API request" do
        expect { perform }.to raise_error(ApplicationService::Exceptions::Failure)

        expect(http_client.request_count).to eq(1)
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

    let(:user_id) { 1 }

    context "when the API request fails" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).not_to be_success
        expect(result).to be_failure
        expect(result.error.type).to eq(:api_error)
        expect(result.error.message).to eq("Request failed")
      end

      it "makes the API request" do
        perform

        expect(http_client.request_count).to eq(1)
      end
    end
  end
end
