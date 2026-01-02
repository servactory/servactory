# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example12, type: :service do
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
              .valid_with(attributes)
              .type(Class)
              .required
          )
        end
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

    describe "and the data required for work is also valid (MyFirstService)" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:service_class, described_class::MyFirstService)
        )
      end
    end

    describe "and the data required for work is also valid (MySecondService)" do
      let(:service_class) { described_class::MySecondService }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:service_class, described_class::MySecondService)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `service_class` is wrong" do
        let(:service_class) { String }

        it "raises a dynamic output error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output `service_class`: String is not allowed. " \
              "Allowed: Usual::DynamicOptions::Target::Example12::MyFirstService, " \
              "Usual::DynamicOptions::Target::Example12::MySecondService"
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
                    outputs: %i[service_class]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_class)
              .valid_with(attributes)
              .type(Class)
              .required
          )
        end
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

    describe "and the data required for work is also valid (MyFirstService)" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:service_class, described_class::MyFirstService)
        )
      end
    end

    describe "and the data required for work is also valid (MySecondService)" do
      let(:service_class) { described_class::MySecondService }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:service_class, described_class::MySecondService)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `service_class` is wrong" do
        let(:service_class) { String }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output `service_class`: String is not allowed. " \
              "Allowed: Usual::DynamicOptions::Target::Example12::MyFirstService, " \
              "Usual::DynamicOptions::Target::Example12::MySecondService"
            )
          )
        end
      end
    end
  end
end
