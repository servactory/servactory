# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example5, type: :service do
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
            .target([described_class::MyFirstService, described_class::MySecondService])
            .valid_with(attributes)
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid (MyFirstService)" do
        it_behaves_like "success result class"
        it do
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        end
      end

      describe "and the data required for work is also valid (MySecondService)" do
        let(:service_class) { described_class::MySecondService }

        it_behaves_like "success result class"
        it do
          expect(perform).to(
            have_output(:result)
              .contains(service_class.name)
          )
        end
      end

      it { expect(perform).to be_success_service }

      it do
        expect(perform).to(
          have_output(:result)
            .contains(service_class.name)
        )
      end
    end

    context "when required data for work is invalid" do
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid (MyFirstService)" do
        it { expect(perform).to be_success_service }
        it { expect(perform).to have_output(:result).contains(service_class.name) }
      end

      describe "and the data required for work is also valid (MySecondService)" do
        let(:service_class) { described_class::MySecondService }

        it { expect(perform).to be_success_service }
        it { expect(perform).to have_output(:result).contains(service_class.name) }
      end

      it { expect(perform).to be_success_service }
      it { expect(perform).to have_output(:result).contains(service_class.name) }
    end

    context "when required data for work is invalid" do
      let(:service_class) { String }

      it "returns expected failure" do
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
