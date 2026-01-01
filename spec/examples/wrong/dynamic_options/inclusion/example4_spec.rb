# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Inclusion::Example4, type: :service do
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
                    internals: %i[event_type],
                    outputs: %i[]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Wrong::DynamicOptions::Inclusion::Example4] " \
              "Internal attribute `event_type` has missing value in `inclusion` option"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:event_name).valid_with(attributes).type(String).required }
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
                    internals: %i[event_type],
                    outputs: %i[]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Wrong::DynamicOptions::Inclusion::Example4] " \
              "Internal attribute `event_type` has missing value in `inclusion` option"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:event_name).valid_with(attributes).type(String).required }
    end
  end
end
