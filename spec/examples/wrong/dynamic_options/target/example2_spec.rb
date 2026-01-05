# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Target::Example2, type: :service do
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

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Target::Example2] " \
              "Input `service_class` has missing value in `target` option"
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
        service_class:
      }
    end

    let(:service_class) { described_class::MyFirstService }

    it_behaves_like "check class info",
                    inputs: %i[service_class],
                    internals: %i[],
                    outputs: %i[]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Target::Example2] " \
              "Input `service_class` has missing value in `target` option"
            )
          )
        end
      end
    end
  end
end
