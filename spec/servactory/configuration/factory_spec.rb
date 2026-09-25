# frozen_string_literal: true

RSpec.describe Servactory::Configuration::Factory do
  let(:positive_helper) do
    Servactory::Maintenance::Options::Helper.new(
      name: :positive,
      equivalent: {
        must: {
          be_positive: {
            is: ->(value:, **) { value.positive? },
            message: "Must be positive"
          }
        }
      }
    )
  end

  describe "#input_option_helpers" do
    context "when called after attributes are declared" do
      let(:service_class) do
        helper = positive_helper

        Class.new(ApplicationService::Base) do
          input :code, :optional, type: String

          configuration do
            input_option_helpers([helper])
          end

          input :number, :positive, type: Integer

          output :number, type: Integer

          make :assign_number

          private

          def assign_number
            outputs.number = inputs.number
          end
        end
      end

      it "applies the helper to attributes declared afterwards", :aggregate_failures do
        expect(service_class.call!(number: 1)).to have_attributes(number: 1)
        expect { service_class.call!(number: -1) }.to raise_error(
          ApplicationService::Exceptions::Input,
          "Must be positive"
        )
      end
    end
  end
end
