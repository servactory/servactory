# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Publishable::Example1, type: :service do
  let(:event_bus) { described_class::LikeAnEventBus }

  before { event_bus.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id,
        should_fail: should_fail
      }
    end

    let(:user_id) { 42 }
    let(:should_fail) { true }

    context "when the service fails" do
      it "raises an error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Failure,
            "User creation failed"
          )
        )
      end

      it "does not publish the event", :aggregate_failures do
        expect { perform }.to raise_error(ApplicationService::Exceptions::Failure)

        expect(event_bus.published_events).to be_empty
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id: user_id,
        should_fail: should_fail
      }
    end

    let(:user_id) { 42 }
    let(:should_fail) { true }

    context "when the service fails" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).not_to be_success
        expect(result).to be_failure
        expect(result.error.type).to eq(:processing_error)
        expect(result.error.message).to eq("User creation failed")
      end

      it "does not publish the event" do
        perform

        expect(event_bus.published_events).to be_empty
      end
    end
  end
end
