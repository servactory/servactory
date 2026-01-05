# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Inclusion::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name:
      }
    end

    let(:event_name) { "created" }

    it_behaves_like "check class info",
                    inputs: %i[event_name],
                    internals: %i[],
                    outputs: %i[]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Inclusion::Example1] " \
              "Input `event_name` has missing value in `inclusion` option"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        event_name:
      }
    end

    let(:event_name) { "created" }

    it_behaves_like "check class info",
                    inputs: %i[event_name],
                    internals: %i[],
                    outputs: %i[]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Inclusion::Example1] " \
              "Input `event_name` has missing value in `inclusion` option"
            )
          )
        end
      end
    end
  end
end
