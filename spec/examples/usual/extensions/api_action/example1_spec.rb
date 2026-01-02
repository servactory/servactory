# frozen_string_literal: true

RSpec.describe Usual::Extensions::ApiAction::Example1, type: :service do
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
          result = perform
          expect(result.user_data).to be_a(Hash)
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with user data" do
        expect(perform).to be_success_service
        expect(perform.user_data).to eq({ id: 1, name: "User from /users/42" })
        expect(http_client.request_count).to eq(1)
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with user data" do
        expect(perform).to be_success_service
        expect(perform.user_data).to eq({ id: 1, name: "User from /users/42" })
      end
    end
  end
end
