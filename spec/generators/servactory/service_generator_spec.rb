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
        expect(content).to include("make :assign_data")
        expect(content).to include("output :data, type: String")
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

    context "with custom model type" do
      before { run_generator %w[ProcessOrder user:User] }

      it "preserves custom type", :aggregate_failures do
        content = file_content("app/services/process_order.rb")
        expect(content).to include("input :user, type: User")
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
      expect(content).not_to include("output :data")
      expect(content).not_to include('outputs.data = "done"')
    end
  end

  describe "#create_service with --path option" do
    before { run_generator %w[ProcessOrder --path=lib/my_gem/services] }

    it "creates service file in custom path", :aggregate_failures do
      assert_file "lib/my_gem/services/process_order.rb"
      assert_no_file "app/services/process_order.rb"

      content = file_content("lib/my_gem/services/process_order.rb")
      expect(content).to include("class ProcessOrder < ApplicationService::Base")
    end
  end

  describe "#create_service with --path option and namespaced name" do
    before { run_generator %w[Users::Create --path=lib/my_gem/services] }

    it "creates service file in custom path with namespace", :aggregate_failures do
      assert_file "lib/my_gem/services/users/create.rb"
      assert_no_file "app/services/users/create.rb"
    end
  end
end
