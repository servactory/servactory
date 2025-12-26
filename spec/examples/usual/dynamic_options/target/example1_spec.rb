# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example1, type: :service do
  let(:attributes) { { service_class: } }
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
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    context "when the input arguments are valid" do
      it { expect(perform).to be_success_service }

      it do
        expect(perform).to(
          have_output(:result)
            .contains("Usual::DynamicOptions::Target::Example1::MyFirstService")
        )
      end
    end

    context "when required data for work is invalid" do
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    context "when the input arguments are valid" do
      it { expect(perform).to be_success_service }
      it { expect(perform).to have_output(:result).contains("Usual::DynamicOptions::Target::Example1::MyFirstService") }
    end

    context "when required data for work is invalid" do
      let(:service_class) { String }

      it "returns expected failure" do
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
