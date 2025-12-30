# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Authorization::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id,
        current_user_id: current_user_id
      }
    end

    let(:user_id) { 123 }
    let(:current_user_id) { 456 }

    context "when the user is not authorized" do
      it "raises an error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Failure,
            "Not authorized to perform this action"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id: user_id,
        current_user_id: current_user_id
      }
    end

    let(:user_id) { 123 }
    let(:current_user_id) { 456 }

    context "when the user is not authorized" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).not_to be_success
        expect(result).to be_failure
        expect(result.error.type).to eq(:unauthorized)
        expect(result.error.message).to eq("Not authorized to perform this action")
      end
    end
  end
end
