# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Base::SubmatcherRegistry do
  let(:test_matcher_class) do
    Class.new do
      include Servactory::TestKit::Rspec::Matchers::Base::SubmatcherRegistry
    end
  end

  describe ".submatcher_definitions" do
    it "returns empty hash by default" do
      expect(test_matcher_class.submatcher_definitions).to eq({})
    end

    it "returns registered definitions" do
      test_matcher_class.register_submatcher(:test_option, class_name: "Test::Submatcher")
      expect(test_matcher_class.submatcher_definitions).to have_key(:test_option)
    end
  end

  describe ".register_submatcher" do
    it "registers a submatcher definition" do
      test_matcher_class.register_submatcher(:test_option, class_name: "Test::Submatcher")

      expect(test_matcher_class.submatcher_definitions).to have_key(:test_option)
    end

    it "sets default values for optional parameters", :aggregate_failures do
      test_matcher_class.register_submatcher(:simple, class_name: "Simple::Submatcher")

      definition = test_matcher_class.submatcher_definitions[:simple]

      expect(definition.name).to eq(:simple)
      expect(definition.class_name).to eq("Simple::Submatcher")
      expect(definition.chain_method).to eq(:simple)
      expect(definition.chain_aliases).to eq([])
      expect(definition.requires_option_types).to be false
      expect(definition.requires_last_submatcher).to be false
      expect(definition.mutually_exclusive_with).to eq([])
      expect(definition.stores_option_types).to be false
      expect(definition.accepts_trailing_options).to be false
    end

    it "accepts custom chain_method" do
      test_matcher_class.register_submatcher(
        :types,
        class_name: "Types::Submatcher",
        chain_method: :type
      )

      definition = test_matcher_class.submatcher_definitions[:types]
      expect(definition.chain_method).to eq(:type)
    end

    it "accepts chain_aliases" do
      test_matcher_class.register_submatcher(
        :types,
        class_name: "Types::Submatcher",
        chain_aliases: [:type]
      )

      definition = test_matcher_class.submatcher_definitions[:types]
      expect(definition.chain_aliases).to eq([:type])
    end

    it "accepts transform_args lambda" do
      transform = ->(args, _kwargs) { args.map(&:to_s) }
      test_matcher_class.register_submatcher(
        :custom,
        class_name: "Custom::Submatcher",
        transform_args: transform
      )

      definition = test_matcher_class.submatcher_definitions[:custom]
      expect(definition.transform_args.call([1, 2], {})).to eq(%w[1 2])
    end

    it "accepts requires_option_types flag" do
      test_matcher_class.register_submatcher(
        :consists_of,
        class_name: "ConsistsOf::Submatcher",
        requires_option_types: true
      )

      definition = test_matcher_class.submatcher_definitions[:consists_of]
      expect(definition.requires_option_types).to be true
    end

    it "accepts requires_last_submatcher flag" do
      test_matcher_class.register_submatcher(
        :message,
        class_name: "Message::Submatcher",
        requires_last_submatcher: true
      )

      definition = test_matcher_class.submatcher_definitions[:message]
      expect(definition.requires_last_submatcher).to be true
    end

    it "accepts mutually_exclusive_with option" do
      test_matcher_class.register_submatcher(
        :required,
        class_name: "Required::Submatcher",
        mutually_exclusive_with: [:optional]
      )

      definition = test_matcher_class.submatcher_definitions[:required]
      expect(definition.mutually_exclusive_with).to eq([:optional])
    end

    it "accepts stores_option_types flag" do
      test_matcher_class.register_submatcher(
        :types,
        class_name: "Types::Submatcher",
        stores_option_types: true
      )

      definition = test_matcher_class.submatcher_definitions[:types]
      expect(definition.stores_option_types).to be true
    end

    it "accepts accepts_trailing_options flag" do
      test_matcher_class.register_submatcher(
        :target,
        class_name: "Target::Submatcher",
        accepts_trailing_options: true
      )

      definition = test_matcher_class.submatcher_definitions[:target]
      expect(definition.accepts_trailing_options).to be true
    end

    it "accepts all configuration options together", :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      test_matcher_class.register_submatcher(
        :full_config,
        class_name: "Full::Submatcher",
        chain_method: :custom_chain,
        chain_aliases: %i[alias_one alias_two],
        transform_args: ->(args, _kwargs) { args.map(&:to_s) },
        requires_option_types: true,
        requires_last_submatcher: true,
        mutually_exclusive_with: [:other],
        stores_option_types: true,
        accepts_trailing_options: true
      )

      definition = test_matcher_class.submatcher_definitions[:full_config]

      expect(definition.name).to eq(:full_config)
      expect(definition.class_name).to eq("Full::Submatcher")
      expect(definition.chain_method).to eq(:custom_chain)
      expect(definition.chain_aliases).to eq(%i[alias_one alias_two])
      expect(definition.requires_option_types).to be true
      expect(definition.requires_last_submatcher).to be true
      expect(definition.mutually_exclusive_with).to eq([:other])
      expect(definition.stores_option_types).to be true
      expect(definition.accepts_trailing_options).to be true
    end
  end

  describe ".inherited" do
    it "copies submatcher definitions to subclass" do
      test_matcher_class.register_submatcher(:parent_option, class_name: "Parent::Submatcher")

      subclass = Class.new(test_matcher_class)

      expect(subclass.submatcher_definitions).to have_key(:parent_option)
    end

    it "isolates subclass modifications from parent", :aggregate_failures do
      test_matcher_class.register_submatcher(:parent_option, class_name: "Parent::Submatcher")

      subclass = Class.new(test_matcher_class)
      subclass.register_submatcher(:child_option, class_name: "Child::Submatcher")

      expect(test_matcher_class.submatcher_definitions).not_to have_key(:child_option)
      expect(subclass.submatcher_definitions).to have_key(:child_option)
      expect(subclass.submatcher_definitions).to have_key(:parent_option)
    end

    it "allows subclass to override parent definitions", :aggregate_failures do
      test_matcher_class.register_submatcher(:shared_option, class_name: "Parent::Submatcher")

      subclass = Class.new(test_matcher_class)
      subclass.register_submatcher(:shared_option, class_name: "Child::Submatcher")

      expect(test_matcher_class.submatcher_definitions[:shared_option].class_name).to eq("Parent::Submatcher")
      expect(subclass.submatcher_definitions[:shared_option].class_name).to eq("Child::Submatcher")
    end
  end

  describe "SubmatcherDefinition" do
    let(:definition_class) do
      Servactory::TestKit::Rspec::Matchers::Base::SubmatcherRegistry::SubmatcherDefinition
    end

    it "is a Struct with keyword_init", :aggregate_failures do
      definition = definition_class.new(
        name: :test,
        class_name: "Test",
        chain_method: :test,
        chain_aliases: [],
        transform_args: ->(args, _kwargs) { args },
        requires_option_types: false,
        requires_last_submatcher: false,
        mutually_exclusive_with: [],
        stores_option_types: false,
        accepts_trailing_options: false
      )

      expect(definition.name).to eq(:test)
      expect(definition.class_name).to eq("Test")
    end

    it "exposes all required attributes", :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      definition = definition_class.new(
        name: :test,
        class_name: "Test",
        chain_method: :test,
        chain_aliases: [:some_alias],
        transform_args: ->(args, _kwargs) { args },
        requires_option_types: true,
        requires_last_submatcher: true,
        mutually_exclusive_with: [:other],
        stores_option_types: true,
        accepts_trailing_options: true
      )

      expect(definition).to respond_to(:name)
      expect(definition).to respond_to(:class_name)
      expect(definition).to respond_to(:chain_method)
      expect(definition).to respond_to(:chain_aliases)
      expect(definition).to respond_to(:transform_args)
      expect(definition).to respond_to(:requires_option_types)
      expect(definition).to respond_to(:requires_last_submatcher)
      expect(definition).to respond_to(:mutually_exclusive_with)
      expect(definition).to respond_to(:stores_option_types)
      expect(definition).to respond_to(:accepts_trailing_options)
    end
  end
end
