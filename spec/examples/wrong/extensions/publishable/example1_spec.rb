# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Publishable::Example1, type: :service do
  let(:event_bus) { described_class::LikeAnEventBus }

  before do
    event_bus.reset!
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 123 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[full_name]

    describe "but the data required for work is invalid" do
      describe "because operation fails before event is published" do
        it "returns expected error and does not publish event", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:user_creation_failed)
              expect(exception.message).to eq("Failed to create user")
              expect(exception.meta).to be_nil
            end
          )
          expect(event_bus.published_events).to be_empty
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

    let(:user_id) { 123 }

    describe "but the data required for work is invalid" do
      describe "because operation fails before event is published" do
        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :user_creation_failed,
            message: "Failed to create user",
            meta: nil
          )
          expect(event_bus.published_events).to be_empty
        end
      end
    end
  end
end
