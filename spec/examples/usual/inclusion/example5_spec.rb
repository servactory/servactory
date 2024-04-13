# frozen_string_literal: true

RSpec.describe Usual::Inclusion::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[],
                     outputs: %i[event]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        describe "and the value of `event_name` is passed" do
          it { expect(perform).to have_output(:event).instance_of(Usual::Inclusion::Example5::Event) }
          it { expect(perform).to have_output(:event).nested(:id).with("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
          it { expect(perform).to have_output(:event).nested(:event_name).with("created") }
        end

        describe "and the value of `event_name` is not passed" do
          let(:event_name) { nil }

          it { expect(perform).to have_output(:event).instance_of(Usual::Inclusion::Example5::Event) }
          it { expect(perform).to have_output(:event).nested(:id).with("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
          it { expect(perform).to have_output(:event).nested(:event_name).with(nil) }
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inclusion::Example5] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:event_name).type(String).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[],
                     outputs: %i[event]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        describe "and the value of `event_name` is passed" do
          it { expect(perform).to have_output(:event).instance_of(Usual::Inclusion::Example5::Event) }
          it { expect(perform).to have_output(:event).nested(:id).with("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
          it { expect(perform).to have_output(:event).nested(:event_name).with("created") }
        end

        describe "and the value of `event_name` is not passed" do
          let(:event_name) { nil }

          it { expect(perform).to have_output(:event).instance_of(Usual::Inclusion::Example5::Event) }
          it { expect(perform).to have_output(:event).nested(:id).with("14fe213e-1b0a-4a68-bca9-ce082db0f2c6") }
          it { expect(perform).to have_output(:event).nested(:event_name).with(nil) }
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inclusion::Example5] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:event_name).type(String).optional }
    end
  end
end
