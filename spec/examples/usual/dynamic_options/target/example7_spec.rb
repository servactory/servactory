# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example7, type: :service do
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
                    internals: %i[service_class],
                    outputs: %i[result]

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

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:service_class)
              .type(Class)
              .target([described_class::MyFirstService], name: :expect)
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

      describe "when the internal value does not pass target validation" do
        let(:service_class) { String }

        it "raises an internal error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Usual::DynamicOptions::Target::Example7] " \
              "Internal attribute `service_class` has wrong target, " \
              "must be `Usual::DynamicOptions::Target::Example7::MyFirstService`, " \
              "got `String`"
            )
          )
        end
      end
    end
  end
end
