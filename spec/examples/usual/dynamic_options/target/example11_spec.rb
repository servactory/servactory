# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example11, type: :service do
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
      describe "and the data required for work is also valid (MyClass1)" do
        it_behaves_like "success result class"
        it {
          expect(perform).to(
            have_output(:result)
              .contains("Usual::DynamicOptions::Target::Example11::MyClass1")
          )
        }
      end

      describe "and the data required for work is also valid (MyClass2)" do
        let(:service_class) { described_class::MyClass2 }

        it_behaves_like "success result class"
        it {
          expect(perform).to(
            have_output(:result)
              .contains("Usual::DynamicOptions::Target::Example11::MyClass2")
          )
        }
      end

      describe "но internal не проходит inclusion" do
        let(:service_class) { String }

        it "возвращает динамическую ошибку internal" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Internal `service_class`: String is not allowed. " \
              "Allowed: Usual::DynamicOptions::Target::Example11::MyClass1, " \
              "Usual::DynamicOptions::Target::Example11::MyClass2"
            )
          )
        end
      end
    end
  end
end
