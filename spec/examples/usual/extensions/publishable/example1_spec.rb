# frozen_string_literal: true

RSpec.describe Usual::Extensions::Publishable::Example1, type: :service do
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
            have_output(:full_name)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, "User 123")
        )
      end

      it "publishes event" do
        perform
        expect(event_bus.published_events).to contain_exactly(
          {
            name: :user_created,
            payload: { user_id: 123, full_name: "User 123" }
          }
        )
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
            have_output(:full_name)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, "User 123")
        )
      end

      it "publishes event" do
        perform
        expect(event_bus.published_events.size).to eq(1)
      end
    end
  end
end
