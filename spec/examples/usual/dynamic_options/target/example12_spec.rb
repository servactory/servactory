# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example12, type: :service do
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
                    outputs: %i[service_class]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_class)
              .type(Class)
              .required
              .valid_with(attributes)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:service_class)
              .instance_of(Class)
          )
        end
      end
    end

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid (MyFirstService)" do
        it_behaves_like "success result class"
        it { expect(perform).to have_output(:service_class).contains(described_class::MyFirstService) }
      end

      describe "and the data required for work is also valid (MySecondService)" do
        let(:service_class) { described_class::MySecondService }

        it_behaves_like "success result class"
        it { expect(perform).to have_output(:service_class).contains(described_class::MySecondService) }
      end

      describe "when output does not pass target validation" do
        let(:service_class) { String }

        it "raises a dynamic output error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output `service_class`: String is not allowed. " \
              "Allowed: Usual::DynamicOptions::Target::Example12::MyFirstService, " \
              "Usual::DynamicOptions::Target::Example12::MySecondService"
            )
          )
        end
      end
    end
  end
end
