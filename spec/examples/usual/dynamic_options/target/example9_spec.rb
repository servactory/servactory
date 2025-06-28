# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example9, type: :service do
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
      it { expect(perform).to be_success_service }

      it {
        expect(perform).to(
          have_output(:service_class)
            .contains(described_class::MyFirstService)
        )
      }
    end

    context "when the output value does not pass target validation" do
      let(:service_class) { String }

      it "raises an output error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Output,
            "[Usual::DynamicOptions::Target::Example9] " \
            "Output attribute `service_class` has wrong target, " \
            "must be `Usual::DynamicOptions::Target::Example9::MyFirstService`, " \
            "got `String`"
          )
        )
      end
    end
  end
end
