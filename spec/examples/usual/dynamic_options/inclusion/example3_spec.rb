# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example3, type: :service do
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
                    outputs: %i[event]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:event_name)
              .valid_with(attributes)
              .type(String)
              .required
              .inclusion(%w[created rejected approved])
          )
        end
      end

      describe "outputs" do
        it { expect(perform).to have_output(:event).instance_of(Usual::DynamicOptions::Inclusion::Example3::Event) }
        it { expect(perform).to have_output(:event).nested(:id).contains("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
        it { expect(perform).to have_output(:event).nested(:event_name).contains("created") }
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example3] Wrong value in `event_name`, " \
              "must be one of `[\"created\", \"rejected\", \"approved\"]`, " \
              "got `\"sent\"`"
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
                    outputs: %i[event]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:event_name)
              .valid_with(attributes)
              .type(String)
              .required
              .inclusion(%w[created rejected approved])
          )
        end
      end

      describe "outputs" do
        it { expect(perform).to have_output(:event).instance_of(Usual::DynamicOptions::Inclusion::Example3::Event) }
        it { expect(perform).to have_output(:event).nested(:id).contains("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
        it { expect(perform).to have_output(:event).nested(:event_name).contains("created") }
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example3] Wrong value in `event_name`, " \
              "must be one of `[\"created\", \"rejected\", \"approved\"]`, " \
              "got `\"sent\"`"
            )
          )
        end
      end
    end
  end
end
