# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example7, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_class:
      }
    end

    let(:service_class) { described_class::MyClass1 }

    it_behaves_like "check class info",
                    inputs: %i[service_class],
                    internals: %i[service_class],
                    outputs: %i[result]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"
        it {
          expect(perform).to(
            have_output(:result)
              .contains("Usual::DynamicOptions::Target::Example7::MyClass1")
          )
        }
      end

      describe "но internal не проходит inclusion" do
        let(:service_class) { String }

        it "возвращает ошибку internal" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Usual::DynamicOptions::Target::Example7] " \
              "Internal attribute `service_class` has wrong target, " \
              "must be `Usual::DynamicOptions::Target::Example7::MyClass1(keyword_init: true)`, " \
              "got `String`"
            )
          )
        end
      end
    end
  end
end
