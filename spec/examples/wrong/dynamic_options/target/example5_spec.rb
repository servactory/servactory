# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Target::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_class:
      }
    end

    let(:service_class) { described_class::TargetA }

    it_behaves_like "check class info",
                    inputs: %i[service_class],
                    internals: %i[],
                    outputs: %i[target_class]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::Target::Example5] " \
              "Output attribute `target_class` has missing value in `target` option"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_class)
              .valid_with(attributes)
              .type(Class)
              .required
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

    let(:service_class) { described_class::TargetA }

    it_behaves_like "check class info",
                    inputs: %i[service_class],
                    internals: %i[],
                    outputs: %i[target_class]

    describe "but the option configuration is invalid" do
      describe "because the `in` option is nil" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::Target::Example5] " \
              "Output attribute `target_class` has missing value in `target` option"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_class)
              .valid_with(attributes)
              .type(Class)
              .required
          )
        end
      end
    end
  end
end
