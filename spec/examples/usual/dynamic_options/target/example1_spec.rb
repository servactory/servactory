# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example1, type: :service do
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
                    outputs: %i[result]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_class)
              .type(Class)
              .required
              .target([described_class::MyFirstService])
              .valid_with(attributes)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:result)
              .instance_of(String)
          )
        end
      end
    end

    context "when the input arguments are valid" do
      it { expect(perform).to be_success_service }

      it {
        expect(perform).to(
          have_output(:result)
            .contains("Usual::DynamicOptions::Target::Example1::MyFirstService")
        )
      }
    end

    context "when the input arguments are invalid" do
      let(:service_class) { String }

      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Usual::DynamicOptions::Target::Example1] " \
            "Input `service_class` has wrong target, " \
            "must be `Usual::DynamicOptions::Target::Example1::MyFirstService`, " \
            "got `String`"
          )
        )
      end
    end
  end
end
