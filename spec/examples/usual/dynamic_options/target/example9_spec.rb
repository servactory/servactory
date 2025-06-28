# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Target::Example9, type: :service do
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
                    internals: %i[],
                    outputs: %i[service_class]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"
        it { expect(perform).to have_output(:service_class).contains(described_class::MyClass1) }
      end

      describe "но output не проходит inclusion" do
        let(:service_class) { String }

        it "возвращает ошибку output" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Usual::DynamicOptions::Target::Example9] " \
              "Output attribute `service_class` has wrong target, " \
              "must be `Usual::DynamicOptions::Target::Example9::MyClass1(keyword_init: true)`, " \
              "got `String`"
            )
          )
        end
      end
    end
  end
end
