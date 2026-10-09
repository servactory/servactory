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

  shared_examples "rejects duplicated option helper names" do |config_name|
    let(:another_positive_helper) do
      Servactory::Maintenance::Options::Helper.new(name: :positive, equivalent: {})
    end

    let(:duplicated_error_message) do
      "Error in `#{config_name}` configuration. " \
        "The `positive` option helper is already defined in this configuration. " \
        "See configuration example here: https://servactory.com/guide/configuration"
    end

    it "raises an error for helpers with the same name in one call" do
      helpers = [positive_helper, another_positive_helper]

      expect do
        Class.new(ApplicationService::Base) do
          configuration { public_send(config_name, helpers) }
        end
      end.to raise_error(ArgumentError, duplicated_error_message)
    end

    it "raises an error for helpers with the same name in separate configuration blocks" do
      first_helper = positive_helper
      second_helper = another_positive_helper

      expect do
        Class.new(ApplicationService::Base) do
          configuration { public_send(config_name, [first_helper]) }
          configuration { public_send(config_name, [second_helper]) }
        end
      end.to raise_error(ArgumentError, duplicated_error_message)
    end

    it "accepts the very same helper more than once" do
      helper = positive_helper

      expect do
        Class.new(ApplicationService::Base) do
          configuration { public_send(config_name, [helper, helper]) }
          configuration { public_send(config_name, [helper]) }
        end
      end.not_to raise_error
    end
  end

  describe "#input_option_helpers" do
    it_behaves_like "reserves built-in option helper names",
                    :input_option_helpers,
                    %i[optional consists_of schema inclusion]

    it_behaves_like "rejects duplicated option helper names", :input_option_helpers

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

    context "when a child class replaces a helper inherited from its parent" do
      let(:parent_class) do
        helper = build_short_helper(3)

        Class.new(ApplicationService::Base) do
          configuration { input_option_helpers([helper]) }
        end
      end

      let(:child_class) do
        helper = build_short_helper(5)

        Class.new(parent_class) do
          configuration { input_option_helpers([helper]) }
        end
      end

      def build_short_helper(max_length)
        Servactory::Maintenance::Options::Helper.new(
          name: :short,
          equivalent: {
            must: { be_short: { is: ->(value:, **) { value.size <= max_length }, message: "At most #{max_length}" } }
          }
        )
      end

      def build_service_with_short_code(base_class)
        Class.new(base_class) do
          input :code, :short, type: String

          output :code, type: String

          private

          def call
            outputs.code = inputs.code
          end
        end
      end

      it "applies the replacement to the child and its descendants", :aggregate_failures do
        service_class = build_service_with_short_code(child_class)

        expect(service_class.call!(code: "abcde")).to have_attributes(code: "abcde")
        expect { service_class.call!(code: "abcdef") }.to(
          raise_error(ApplicationService::Exceptions::Input, "At most 5")
        )
      end

      it "keeps the helper of the parent", :aggregate_failures do
        child_class
        service_class = build_service_with_short_code(parent_class)

        expect(service_class.call!(code: "abc")).to have_attributes(code: "abc")
        expect { service_class.call!(code: "abcd") }.to(
          raise_error(ApplicationService::Exceptions::Input, "At most 3")
        )
      end

      it "raises an error for a second replacement in the same child" do
        first_helper = build_short_helper(5)
        second_helper = build_short_helper(7)

        expect do
          Class.new(parent_class) do
            configuration { input_option_helpers([first_helper]) }
            configuration { input_option_helpers([second_helper]) }
          end
        end.to raise_error(ArgumentError, /The `short` option helper is already defined in this configuration/)
      end

      it "allows a grandchild to replace the helper again" do
        helper = build_short_helper(7)

        expect do
          Class.new(child_class) { configuration { input_option_helpers([helper]) } }
        end.not_to raise_error
      end
    end

    context "when a child class registers the same tool kit helpers as its parent" do
      let(:parent_class) do
        Class.new(Servactory::Base) do
          configuration do
            input_option_helpers(
              [Servactory::ToolKit::DynamicOptions::Format.use, Servactory::ToolKit::DynamicOptions::Min.use]
            )
          end
        end
      end

      let(:service_class) do
        Class.new(parent_class) do
          configuration do
            input_option_helpers(
              [Servactory::ToolKit::DynamicOptions::Format.use, Servactory::ToolKit::DynamicOptions::Min.use]
            )
          end

          input :email, type: String, format: :email
          input :age, type: Integer, min: 18

          private

          def call; end
        end
      end

      it "applies the helpers registered by the child", :aggregate_failures do
        expect(service_class.call!(email: "john@example.com", age: 18)).to be_success
        expect { service_class.call!(email: "john", age: 18) }.to raise_error(Servactory::Exceptions::Input)
        expect { service_class.call!(email: "john@example.com", age: 17) }.to raise_error(Servactory::Exceptions::Input)
      end
    end
  end

  describe "#internal_option_helpers" do
    it_behaves_like "reserves built-in option helper names",
                    :internal_option_helpers,
                    %i[consists_of schema inclusion]

    it_behaves_like "rejects duplicated option helper names", :internal_option_helpers

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

    it_behaves_like "rejects duplicated option helper names", :output_option_helpers

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
