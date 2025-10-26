# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example9, type: :service do
  let(:attributes) { { service_class: } }
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
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    context "when the input arguments are valid" do
      it { expect(perform).to be_success_service }

      it do
        expect(perform).to(
          have_output(:service_class)
            .contains(described_class::MyFirstService)
        )
      end
    end

    context "when required data for work is invalid" do
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    context "when the input arguments are valid" do
      it { expect(perform).to be_success_service }
      it { expect(perform).to have_output(:service_class).contains(described_class::MyFirstService) }
    end

    context "when required data for work is invalid" do
      let(:service_class) { String }

      it "returns expected failure" do
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
