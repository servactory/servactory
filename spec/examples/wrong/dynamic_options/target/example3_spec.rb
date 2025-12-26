# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Target::Example3, type: :service do
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
                    internals: %i[target_class],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the option configuration is invalid" do
        describe "because the `in` option is nil" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Wrong::DynamicOptions::Target::Example3] " \
                "Internal attribute `target_class` has missing value in `expect` option"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:service_class).valid_with(attributes).type(Class).required }
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
                    internals: %i[target_class],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the option configuration is invalid" do
        describe "because the `in` option is nil" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Wrong::DynamicOptions::Target::Example3] " \
                "Internal attribute `target_class` has missing value in `expect` option"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:service_class).valid_with(attributes).type(Class).required }
    end
  end
end
