# frozen_string_literal: true

require "spec_helper"

RSPEC_GENERATOR_AVAILABLE = begin
  require "generators/servactory/rspec/rspec_generator"
  true
rescue LoadError
  false
end

RSpec.describe "Servactory::Generators::RspecGenerator", skip: !RSPEC_GENERATOR_AVAILABLE do
  include GeneratorHelpers

  tests Servactory::Generators::RspecGenerator if RSPEC_GENERATOR_AVAILABLE

  describe "#create_spec_file" do
    context "with simple name" do
      before { run_generator %w[ProcessOrder] }

      it "creates spec file in spec/services/ NOT app/services/", :aggregate_failures do
        assert_file "spec/services/process_order_spec.rb"
        assert_no_file "app/services/process_order_spec.rb"
      end

      it "creates spec with correct structure", :aggregate_failures do
        content = file_content("spec/services/process_order_spec.rb")
        expect(content).to include("RSpec.describe ProcessOrder, type: :service do")
        expect(content).to include('pending "add some examples to (or delete) #{__FILE__}"')
        expect(content).to include('describe ".call!" do')
        expect(content).to include("subject(:perform) { described_class.call!(**attributes) }")
      end

      it "creates spec with placeholder for attributes when service not loaded", :aggregate_failures do
        content = file_content("spec/services/process_order_spec.rb")
        expect(content).to include("let(:attributes) do")
        expect(content).to include("# TODO: Add input attributes")
      end
    end

    context "with namespaced name" do
      before { run_generator %w[Users::Create] }

      it "creates spec file in correct directory", :aggregate_failures do
        assert_file "spec/services/users/create_spec.rb"

        content = file_content("spec/services/users/create_spec.rb")
        expect(content).to include("RSpec.describe Users::Create, type: :service do")
      end
    end

    context "with --call-method=call option" do
      before { run_generator %w[ProcessOrder --call-method=call] }

      it "uses .call instead of .call!", :aggregate_failures do
        content = file_content("spec/services/process_order_spec.rb")
        expect(content).to include('describe ".call" do')
        expect(content).to include("subject(:perform) { described_class.call(**attributes) }")
        expect(content).not_to include(".call!")
      end
    end

    context "with --path option" do
      before { run_generator %w[ProcessOrder --path=spec/lib/my_gem/services] }

      it "creates spec file in custom path", :aggregate_failures do
        assert_file "spec/lib/my_gem/services/process_order_spec.rb"
        assert_no_file "spec/services/process_order_spec.rb"
      end
    end

    context "with --path option and namespaced name" do
      before { run_generator %w[Users::Create --path=spec/lib/my_gem/services] }

      it "creates spec file in custom path with namespace", :aggregate_failures do
        assert_file "spec/lib/my_gem/services/users/create_spec.rb"
        assert_no_file "spec/services/users/create_spec.rb"
      end
    end

    context "with --skip-validations option" do
      before { run_generator %w[ProcessOrder --skip-validations] }

      it "creates spec without validation examples", :aggregate_failures do
        content = file_content("spec/services/process_order_spec.rb")
        expect(content).not_to include('describe "validations"')
      end
    end

    context "with --skip-pending option" do
      before { run_generator %w[ProcessOrder --skip-pending] }

      it "creates spec without pending placeholder", :aggregate_failures do
        content = file_content("spec/services/process_order_spec.rb")
        expect(content).not_to include("pending")
      end
    end
  end
end
