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
              .valid_with(attributes)
              .type(Class)
              .required
              .target([described_class::MyFirstService, described_class::MySecondService])
          )
        end
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

    describe "and the data required for work is also valid (MyFirstService)" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:result, service_class.name)
        )
      end
    end

    describe "and the data required for work is also valid (MySecondService)" do
      let(:service_class) { described_class::MySecondService }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:result, service_class.name)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `service_class` is wrong" do
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

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
              .valid_with(attributes)
              .type(Class)
              .required
              .target([described_class::MyFirstService, described_class::MySecondService])
          )
        end
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

    describe "and the data required for work is also valid (MyFirstService)" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:result, service_class.name)
        )
      end
    end

    describe "and the data required for work is also valid (MySecondService)" do
      let(:service_class) { described_class::MySecondService }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:result, service_class.name)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `service_class` is wrong" do
        let(:service_class) { String }

        it "returns expected error" do
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
end
