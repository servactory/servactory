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

  shared_examples "reserves built-in option helper names" do |config_name, builtin_names|
    builtin_names.each do |builtin_name|
      it "raises an error for a custom `#{builtin_name}` helper" do
        helper = Servactory::Maintenance::Options::Helper.new(name: builtin_name, equivalent: {})

        expect do
          Class.new(ApplicationService::Base) do
            configuration { public_send(config_name, [helper]) }
          end
        end.to raise_error(
          ArgumentError,
          "Error in `#{config_name}` configuration. " \
          "The `#{builtin_name}` option helper name is reserved by a built-in option helper. " \
          "See configuration example here: https://servactory.com/guide/configuration"
        )
      end
    end

    it "accepts the registered built-in helper itself" do
      helper = ApplicationService::Base.config.public_send(config_name).find_by(name: :inclusion)

      expect do
        Class.new(ApplicationService::Base) do
          configuration { public_send(config_name, [helper]) }
        end
      end.not_to raise_error
    end
  end

  describe "#input_option_helpers" do
    it_behaves_like "reserves built-in option helper names",
                    :input_option_helpers,
                    %i[optional consists_of schema inclusion]

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

  describe "#internal_option_helpers" do
    it_behaves_like "reserves built-in option helper names",
                    :internal_option_helpers,
                    %i[consists_of schema inclusion]

    it "accepts a helper named after a built-in helper of inputs only" do
      helper = Servactory::Maintenance::Options::Helper.new(name: :optional, equivalent: {})

      expect do
        Class.new(ApplicationService::Base) do
          configuration { internal_option_helpers([helper]) }
        end
      end.not_to raise_error
    end
  end

  describe "#output_option_helpers" do
    it_behaves_like "reserves built-in option helper names",
                    :output_option_helpers,
                    %i[consists_of schema inclusion]

    it "accepts a helper named after a built-in helper of inputs only" do
      helper = Servactory::Maintenance::Options::Helper.new(name: :optional, equivalent: {})

      expect do
        Class.new(ApplicationService::Base) do
          configuration { output_option_helpers([helper]) }
        end
      end.not_to raise_error
    end
  end
end
