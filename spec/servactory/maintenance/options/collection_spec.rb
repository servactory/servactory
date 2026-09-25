# frozen_string_literal: true

RSpec.describe Servactory::Maintenance::Options::Collection do
  subject(:collection) { service_class.send(:collection_of_inputs).find_by(name: :number).collection_of_options }

  let(:service_class) do
    Class.new(ApplicationService::Base) do
      input :number,
            type: Integer,
            required: false,
            default: 1,
            must: {
              be_positive: {
                is: ->(value:, **) { value.positive? }
              }
            }
    end
  end

  describe "#validation_classes" do
    let(:deprecation_warning) do
      "[DEPRECATION] Servactory::Maintenance::Options::Collection#validation_classes is deprecated. " \
        "Use #validations_for_checks instead.\n"
    end

    it "warns about deprecation" do
      expect { collection.validation_classes }.to output(deprecation_warning).to_stderr
    end

    it "returns unique validation classes from validations for checks", :aggregate_failures do
      validation_classes = nil

      expect { validation_classes = collection.validation_classes }.to output(deprecation_warning).to_stderr

      expect(validation_classes).to eq(
        [
          Servactory::Inputs::Validations::Required,
          Servactory::Maintenance::Validations::Checkers::Type,
          Servactory::Maintenance::Validations::Checkers::Must
        ]
      )
      expect(validation_classes).to eq(collection.validations_for_checks.map(&:last).uniq)
    end
  end

  describe "#options_for_checks" do
    let(:deprecation_warning) do
      "[DEPRECATION] Servactory::Maintenance::Options::Collection#options_for_checks is deprecated. " \
        "Use #validations_for_checks instead.\n"
    end

    it "warns about deprecation" do
      expect { collection.options_for_checks }.to output(deprecation_warning).to_stderr
    end

    it "returns check options keyed by option name", :aggregate_failures do
      options_for_checks = nil

      expect { options_for_checks = collection.options_for_checks }.to output(deprecation_warning).to_stderr

      expect(options_for_checks.keys).to eq(%i[required types must])
      expect(options_for_checks).to eq(
        collection.validations_for_checks.to_h { |check_key, check_options, _| [check_key, check_options] }
      )
    end
  end
end
