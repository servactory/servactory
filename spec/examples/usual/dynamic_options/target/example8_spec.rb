# frozen_string_literal: true

# TODO: Need to add a wrong example to test the exception.
RSpec.describe Usual::DynamicOptions::Target::Example8, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    let(:service_class) { described_class::MyFirstService }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[service_class],
                    outputs: %i[result]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:service_class)
              .type(Class)
              .target(
                [described_class::MyFirstService, described_class::MySecondService],
                name: :expect
              )
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:result, service_class.name)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    let(:service_class) { described_class::MyFirstService }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[service_class],
                    outputs: %i[result]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:service_class)
              .type(Class)
              .target(
                [described_class::MyFirstService, described_class::MySecondService],
                name: :expect
              )
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:result, service_class.name)
        )
      end
    end
  end
end
