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
    describe "service file creation" do
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
    end

    describe "input type handling" do
      context "with lowercase types (Rails format)" do
        before { run_generator %w[Users::Create email:string count:integer] }

        it "normalizes lowercase types to Ruby classes", :aggregate_failures do
          content = file_content("app/services/users/create.rb")
          expect(content).to include("input :email, type: String")
          expect(content).to include("input :count, type: Integer")
        end
      end

      context "with capitalized types (Ruby class names)" do
        before { run_generator %w[Users::Create email:String count:Integer] }

        it "preserves capitalized Ruby class names", :aggregate_failures do
          content = file_content("app/services/users/create.rb")
          expect(content).to include("input :email, type: String")
          expect(content).to include("input :count, type: Integer")
        end
      end

      context "with custom model types" do
        before { run_generator %w[ProcessOrder user:User event:Event] }

        it "preserves custom type names", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :user, type: User")
          expect(content).to include("input :event, type: Event")
        end
      end

      context "with nested namespace types" do
        before { run_generator %w[ProcessOrder role:Admin::Users::Role status:Billing::PaymentStatus] }

        it "preserves nested namespace types", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :role, type: Admin::Users::Role")
          expect(content).to include("input :status, type: Billing::PaymentStatus")
        end
      end

      context "with boolean type variations" do
        before { run_generator %w[ToggleFeature enabled:boolean flag:bool] }

        it "normalizes boolean types to TrueClass/FalseClass array", :aggregate_failures do
          content = file_content("app/services/toggle_feature.rb")
          expect(content).to include("input :enabled, type: [TrueClass, FalseClass]")
          expect(content).to include("input :flag, type: [TrueClass, FalseClass]")
        end
      end

      context "with untyped inputs" do
        before { run_generator %w[SendEmail recipient subject] }

        it "defaults to String type", :aggregate_failures do
          content = file_content("app/services/send_email.rb")
          expect(content).to include("input :recipient, type: String")
          expect(content).to include("input :subject, type: String")
        end
      end
    end

    describe "generator options" do
      context "with --base-class option" do
        before { run_generator %w[ProcessOrder --base-class=CustomService::Base] }

        it "uses custom base class", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("class ProcessOrder < CustomService::Base")
        end
      end

      context "with --path option" do
        before { run_generator %w[ProcessOrder --path=lib/my_gem/services] }

        it "creates service file in custom path", :aggregate_failures do
          assert_file "lib/my_gem/services/process_order.rb"
          assert_no_file "app/services/process_order.rb"

          content = file_content("lib/my_gem/services/process_order.rb")
          expect(content).to include("class ProcessOrder < ApplicationService::Base")
        end
      end

      context "with --path option and namespaced name" do
        before { run_generator %w[Users::Create --path=lib/my_gem/services] }

        it "creates service file in custom path with namespace", :aggregate_failures do
          assert_file "lib/my_gem/services/users/create.rb"
          assert_no_file "app/services/users/create.rb"
        end
      end

      context "with --skip-output option" do
        before { run_generator %w[ProcessOrder --skip-output] }

        it "does not include output declaration", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).not_to include("output :data")
          expect(content).not_to include('outputs.data = "done"')
        end
      end
    end
  end
end
