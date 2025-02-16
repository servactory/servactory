# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name:
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
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
              .inclusion(%w[created rejected approved]) { be_a(Proc) }
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:event)
              .instance_of(Usual::DynamicOptions::Inclusion::Example4::Event)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:event).instance_of(Usual::DynamicOptions::Inclusion::Example4::Event) }
      it { expect(perform).to have_output(:event).nested(:id).contains("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
      it { expect(perform).to have_output(:event).nested(:event_name).contains("created") }
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Incorrect `event_name` specified: `sent`"
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

    include_examples "check class info",
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
              .inclusion(%w[created rejected approved]) { be_a(Proc) }
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:event)
              .instance_of(Usual::DynamicOptions::Inclusion::Example4::Event)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:event).instance_of(Usual::DynamicOptions::Inclusion::Example4::Event) }
      it { expect(perform).to have_output(:event).nested(:id).contains("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
      it { expect(perform).to have_output(:event).nested(:event_name).contains("created") }
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Incorrect `event_name` specified: `sent`"
            )
          )
        end
      end
    end
  end
end
