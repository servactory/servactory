# frozen_string_literal: true

RSpec.describe Usual::Extensions::ExternalApiRequest::Example1, type: :service do
  let(:api_client) { described_class::LikeAnApiClient }
  let(:api_response_class) { described_class::LikeAnApiResponse }

  before { api_client.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id
      }
    end

    let(:user_id) { 99 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[response]

    context "when the input arguments are valid" do
      describe "and the API request succeeds" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.response).to be_a(api_response_class)
          expect(result.response.id).to eq(99)
          expect(result.response.name).to eq("User 99")
        end

        it "makes the API request" do
          perform

          expect(api_client.request_count).to eq(1)
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:user_id)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
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

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[response]

    context "when the input arguments are valid" do
      describe "and the API request succeeds" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.response).to be_a(api_response_class)
          expect(result.response.id).to eq(99)
          expect(result.response.name).to eq("User 99")
        end

        it "makes the API request" do
          perform

          expect(api_client.request_count).to eq(1)
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:user_id)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end
end
