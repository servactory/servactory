# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example7, type: :service do
  let(:attributes) { { service_class: } }
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
            .target(
              described_class::MyFirstService,
              name: :expect
            )
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"
        it do
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        end
      end

      context "when required data for work is invalid" do
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to be_success_service }
        it { expect(perform).to have_output(:result).contains(service_class.name) }
      end

      context "when required data for work is invalid" do
        let(:service_class) { String }

        it "returns expected failure" do
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
