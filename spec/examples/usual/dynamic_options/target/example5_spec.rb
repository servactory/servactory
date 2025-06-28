# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example5, type: :service do
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
              .target([described_class::MyFirstService, described_class::MySecondService])
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
      describe "and the data required for work is also valid (MyFirstService)" do
        it_behaves_like "success result class"
        it {
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        }
      end

      describe "and the data required for work is also valid (MySecondService)" do
        let(:service_class) { described_class::MySecondService }

        it_behaves_like "success result class"
        it {
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        }
      end

      it { expect(perform).to be_success_service }

      it {
        expect(perform).to(
          have_output(:result)
            .contains(service_class.name)
        )
      }
    end

    context "when the input arguments are invalid" do
      let(:service_class) { String }

      it "raises a custom error for array" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Custom error for array"
          )
        )
      end
    end
  end
end
