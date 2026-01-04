# frozen_string_literal: true

require "spec_helper"

SERVICE_GENERATOR_AVAILABLE = begin
  require "generators/servactory/service/service_generator"
  true
rescue LoadError
  false
end

RSpec.describe "Servactory::Generators::ServiceGenerator", skip: !SERVICE_GENERATOR_AVAILABLE do
  include GeneratorHelpers

  tests Servactory::Generators::ServiceGenerator if SERVICE_GENERATOR_AVAILABLE

  describe "#create_service" do
    context "with simple name" do
      before { run_generator %w[ProcessOrder] }

      it "creates service file", :aggregate_failures do
        assert_file "app/services/process_order.rb"

        content = file_content("app/services/process_order.rb")
        expect(content).to include("class ProcessOrder < ApplicationService::Base")
        expect(content).to include("make :call")
        expect(content).to include("output :result, type: Symbol")
      end
    end

    context "with namespaced name" do
      before { run_generator %w[Users::Create] }

      it "creates service file in correct directory", :aggregate_failures do
        assert_file "app/services/users/create.rb"

        content = file_content("app/services/users/create.rb")
        expect(content).to include("class Users::Create < ApplicationService::Base")
      end
    end

    context "with typed inputs" do
      before { run_generator %w[Users::Create email:String count:Integer] }

      it "creates service with typed inputs", :aggregate_failures do
        content = file_content("app/services/users/create.rb")
        expect(content).to include("input :email, type: String")
        expect(content).to include("input :count, type: Integer")
      end
    end

    context "with untyped inputs" do
      before { run_generator %w[SendEmail recipient] }

      it "defaults to String type", :aggregate_failures do
        content = file_content("app/services/send_email.rb")
        expect(content).to include("input :recipient, type: String")
      end
    end
  end

  describe "#create_service with --base-class option" do
    before { run_generator %w[ProcessOrder --base-class=CustomService::Base] }

    it "uses custom base class", :aggregate_failures do
      content = file_content("app/services/process_order.rb")
      expect(content).to include("class ProcessOrder < CustomService::Base")
    end
  end

  describe "#create_service with --skip-output option" do
    before { run_generator %w[ProcessOrder --skip-output] }

    it "does not include output declaration", :aggregate_failures do
      content = file_content("app/services/process_order.rb")
      expect(content).not_to include("output :result")
    end
  end

  describe "#create_service with --skip-make option" do
    before { run_generator %w[ProcessOrder --skip-make] }

    it "does not include make declaration and call method", :aggregate_failures do
      content = file_content("app/services/process_order.rb")
      expect(content).not_to include("make :call")
      expect(content).not_to include("def call")
    end
  end

  describe "#create_service with --internal option" do
    before { run_generator %w[ProcessOrder --internal=cache_key temp_data] }

    it "includes internal declarations", :aggregate_failures do
      content = file_content("app/services/process_order.rb")
      expect(content).to include("internal :cache_key, type: String")
      expect(content).to include("internal :temp_data, type: String")
    end
  end

  describe "#create_service with --output option" do
    before { run_generator %w[ProcessOrder --output=receipt status] }

    it "includes custom output declarations", :aggregate_failures do
      content = file_content("app/services/process_order.rb")
      expect(content).to include("output :receipt, type: Symbol")
      expect(content).to include("output :status, type: Symbol")
      expect(content).to include("outputs.receipt = :done")
      expect(content).to include("outputs.status = :done")
    end
  end
end
