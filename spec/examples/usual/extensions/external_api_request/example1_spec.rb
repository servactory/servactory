# frozen_string_literal: true

RSpec.describe Usual::Extensions::ExternalApiRequest::Example1, type: :service do
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

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:user_id)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:api_response)
              .instance_of(described_class::LikeAnApiResponse)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to be_success_service
      end

      it "returns API response with correct attributes", :aggregate_failures do
        result = perform
        expect(result.api_response.id).to eq(99)
        expect(result.api_response.name).to eq("User 99")
      end

      it "makes single API request" do
        perform
        expect(api_client.request_count).to eq(1)
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

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:user_id)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:api_response)
              .instance_of(described_class::LikeAnApiResponse)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to be_success_service
      end

      it "returns API response with correct attributes", :aggregate_failures do
        result = perform
        expect(result.api_response.id).to eq(99)
        expect(result.api_response.name).to eq("User 99")
      end
    end
  end
end
