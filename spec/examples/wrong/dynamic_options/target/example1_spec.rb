# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Target::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_class:
      }
    end

    let(:service_class) { described_class::MyFirstService }

    it_behaves_like "check class info",
                    inputs: %i[service_class],
                    internals: %i[],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the option configuration is invalid" do
        describe "because the `in` option is nil" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Target::Example1] " \
                "Input `service_class` has missing value in `target` option"
              )
            )
          end
        end
      end
    end

    # NOTE: Will not work due to the `nil` value in the option.
    # context "when the input arguments are invalid" do
    #   it { expect { perform }.to have_input(:service_class).valid_with(attributes).type(Class).required }
    # end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        service_class:
      }
    end

    let(:service_class) { described_class::MyFirstService }

    it_behaves_like "check class info",
                    inputs: %i[service_class],
                    internals: %i[],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the option configuration is invalid" do
        describe "because the `in` option is nil" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Target::Example1] " \
                "Input `service_class` has missing value in `target` option"
              )
            )
          end
        end
      end
    end

    # NOTE: Will not work due to the `nil` value in the option.
    # context "when the input arguments are invalid" do
    #   it { expect { perform }.to have_input(:service_class).valid_with(attributes).type(Class).required }
    # end
  end
end
