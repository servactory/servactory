# frozen_string_literal: true

RSpec.describe Servactory::Maintenance::Attributes::Base do
  describe "#options_for_checks" do
    subject(:input) { service_class.send(:collection_of_inputs).find_by(name: :number) }

    let(:service_class) do
      Class.new(ApplicationService::Base) do
        input :number, type: Integer, required: false, default: 1
      end
    end

    let(:deprecation_warning) do
      "[DEPRECATION] Servactory::Maintenance::Attributes::Base#options_for_checks is deprecated. " \
        "Use collection_of_options.validations_for_checks instead.\n"
    end

    it "warns once about its own deprecation and returns the check options", :aggregate_failures do
      options_for_checks = nil

      expect { options_for_checks = input.options_for_checks }.to output(deprecation_warning).to_stderr

      expect(options_for_checks).to eq(required: false, types: [Integer], must: nil)
    end
  end
end
