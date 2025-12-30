# frozen_string_literal: true

RSpec.describe Usual::Extensions::ApiAction::Example1, type: :service do
  let(:http_client) { described_class::LikeAnHttpClient }

  before { http_client.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id
      }
    end

    let(:user_id) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[response],
                    outputs: %i[user_data]

    context "when the input arguments are valid" do
      describe "and the API request succeeds" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.user_data).to eq({ id: 1, name: "User from /users/1" })
        end

        it "makes the API request" do
          perform

          expect(http_client.request_count).to eq(1)
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

    let(:user_id) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[response],
                    outputs: %i[user_data]

    context "when the input arguments are valid" do
      describe "and the API request succeeds" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.user_data).to eq({ id: 1, name: "User from /users/1" })
        end

        it "makes the API request" do
          perform

          expect(http_client.request_count).to eq(1)
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
