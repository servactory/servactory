# frozen_string_literal: true

RSpec.describe Servactory::Maintenance::Attributes::OptionHelper do
  let(:deprecation_warning) do
    "[DEPRECATION] Servactory::Maintenance::Attributes::OptionHelper is deprecated. " \
      "Use Servactory::Maintenance::Options::Helper instead.\n"
  end

  describe ".new" do
    it "warns about deprecation" do
      expect { described_class.new(name: :optional, equivalent: { required: false }) }.to(
        output(deprecation_warning).to_stderr
      )
    end

    it "builds an option helper", :aggregate_failures do
      option_helper = nil

      expect do
        option_helper = described_class.new(name: :optional, equivalent: { required: false }, meta: { note: :legacy })
      end.to output(deprecation_warning).to_stderr

      expect(option_helper).to be_a(Servactory::Maintenance::Options::Helper)
      expect(option_helper).to have_attributes(
        name: :optional,
        equivalent: { required: false },
        meta: { note: :legacy },
        dynamic_option?: false
      )
    end
  end

  describe "service configuration" do
    let(:service_class) do
      Class.new(ApplicationService::Base) do
        configuration do
          input_option_helpers(
            [
              Servactory::Maintenance::Attributes::OptionHelper.new(
                name: :must_be_positive,
                equivalent: {
                  must: {
                    be_positive: {
                      is: ->(value:, **) { value.positive? },
                      message: "Must be positive"
                    }
                  }
                }
              )
            ]
          )
        end

        input :number, :must_be_positive, type: Integer

        output :positive_number, type: Integer

        make :assign_positive_number

        private

        def assign_positive_number
          outputs.positive_number = inputs.number
        end
      end
    end

    it "applies the equivalent options", :aggregate_failures do
      expect { service_class }.to output(deprecation_warning).to_stderr

      expect(service_class.call!(number: 1)).to have_attributes(positive_number: 1)
      expect { service_class.call!(number: -1) }.to raise_error(
        ApplicationService::Exceptions::Input,
        "Must be positive"
      )
    end
  end
end
