# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example2, type: :service do
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
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it {
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        }
      end

      describe "but the data required for work is also valid (second class)" do
        let(:service_class) { described_class::MySecondService }

        it_behaves_like "success result class"
        it {
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `service_class` is wrong" do
          let(:service_class) { String }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Target::Example2] " \
                "Input `service_class` has wrong target, " \
                "must be `[Usual::DynamicOptions::Target::Example2::MyFirstService, " \
                "Usual::DynamicOptions::Target::Example2::MySecondService]`, " \
                "got `String`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      let(:service_class) { String }

      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Usual::DynamicOptions::Target::Example2] " \
            "Input `service_class` has wrong target, " \
            "must be `[Usual::DynamicOptions::Target::Example2::MyFirstService, " \
            "Usual::DynamicOptions::Target::Example2::MySecondService]`, " \
            "got `String`"
          )
        )
      end
    end
  end
end
