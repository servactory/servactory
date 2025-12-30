# frozen_string_literal: true

RSpec.describe Usual::Extensions::Publishable::Example1, type: :service do
  let(:event_bus) { described_class::LikeAnEventBus }

  before { event_bus.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id
      }
    end

    let(:user_id) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[user_name]

    context "when the input arguments are valid" do
      describe "and the service succeeds" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.user_name).to eq("User 42")
        end

        it "publishes the event with correct payload", :aggregate_failures do
          perform

          expect(event_bus.published_events.size).to eq(1)
          expect(event_bus.published_events.first[:name]).to eq(:user_created)
          expect(event_bus.published_events.first[:payload]).to eq(
            { user_id: 42, user_name: "User 42" }
          )
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

    let(:user_id) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[user_name]

    context "when the input arguments are valid" do
      describe "and the service succeeds" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.user_name).to eq("User 42")
        end

        it "publishes the event with correct payload", :aggregate_failures do
          perform

          expect(event_bus.published_events.size).to eq(1)
          expect(event_bus.published_events.first[:name]).to eq(:user_created)
          expect(event_bus.published_events.first[:payload]).to eq(
            { user_id: 42, user_name: "User 42" }
          )
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
