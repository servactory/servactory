# frozen_string_literal: true

require "generators/servactory/extension/extension_generator"

RSpec.describe "Servactory::Generators::ExtensionGenerator" do
  include GeneratorHelpers

  tests Servactory::Generators::ExtensionGenerator

  describe "#create_extension" do
    describe "file creation" do
      context "with simple name" do
        before { run_generator %w[MyExtension] }

        it "creates extension file at default path", :aggregate_failures do
          assert_file "app/services/application_service/extensions/my_extension/dsl.rb"

          content = file_content("app/services/application_service/extensions/my_extension/dsl.rb")
          expect(content).to include("module ApplicationService")
          expect(content).to include("module Extensions")
          expect(content).to include("module MyExtension")
          expect(content).to include("module DSL")
        end

        it "includes self.included hook with ClassMethods and InstanceMethods", :aggregate_failures do
          content = file_content("app/services/application_service/extensions/my_extension/dsl.rb")
          expect(content).to include("def self.included(base)")
          expect(content).to include("base.extend(ClassMethods)")
          expect(content).to include("base.include(InstanceMethods)")
        end

        it "includes ClassMethods module with DSL method", :aggregate_failures do
          content = file_content("app/services/application_service/extensions/my_extension/dsl.rb")
          expect(content).to include("module ClassMethods")
          expect(content).to include("def my_extension!(my_setting: nil)")
          expect(content).to include("stroma.settings[:actions][:my_extension][:my_setting] = my_setting")
        end

        it "includes InstanceMethods module with call! override", :aggregate_failures do
          content = file_content("app/services/application_service/extensions/my_extension/dsl.rb")
          expect(content).to include("module InstanceMethods")
          expect(content).to include("def call!(**)")
          expect(content).to include("self.class.stroma.settings[:actions][:my_extension][:my_setting]")
          expect(content).to include("super")
        end
      end

      context "with namespaced name" do
        before { run_generator %w[Admin::AuditTrail] }

        it "creates extension file in correct directory", :aggregate_failures do
          assert_file "app/services/application_service/extensions/admin/audit_trail/dsl.rb"

          content = file_content("app/services/application_service/extensions/admin/audit_trail/dsl.rb")
          expect(content).to include("module Admin::AuditTrail")
        end

        it "uses underscored extension key for settings", :aggregate_failures do
          content = file_content("app/services/application_service/extensions/admin/audit_trail/dsl.rb")
          expect(content).to include("def admin_audit_trail!(my_setting: nil)")
          expect(content).to include("stroma.settings[:actions][:admin_audit_trail][:my_setting]")
        end
      end

      context "with deeply nested namespace" do
        before { run_generator %w[Admin::Users::Permissions::AuditTrail] }

        it "creates extension file in correct directory", :aggregate_failures do
          assert_file "app/services/application_service/extensions/admin/users/permissions/audit_trail/dsl.rb"

          content =
            file_content("app/services/application_service/extensions/admin/users/permissions/audit_trail/dsl.rb")
          expect(content).to include("module Admin::Users::Permissions::AuditTrail")
          expect(content).to include("stroma.settings[:actions][:admin_users_permissions_audit_trail]")
        end
      end
    end

    describe "generator options" do
      context "with --path option" do
        before { run_generator %w[MyExtension --path=lib/my_gem/extensions] }

        it "creates extension file in custom path", :aggregate_failures do
          assert_file "lib/my_gem/extensions/my_extension/dsl.rb"
          assert_no_file "app/services/application_service/extensions/my_extension/dsl.rb"

          content = file_content("lib/my_gem/extensions/my_extension/dsl.rb")
          expect(content).to include("module ApplicationService")
          expect(content).to include("module MyExtension")
        end
      end

      context "with --path option and namespaced name" do
        before { run_generator %w[Admin::AuditTrail --path=lib/my_gem/extensions] }

        it "creates extension file in custom path with namespace", :aggregate_failures do
          assert_file "lib/my_gem/extensions/admin/audit_trail/dsl.rb"
          assert_no_file "app/services/application_service/extensions/admin/audit_trail/dsl.rb"
        end
      end

      context "with --namespace option" do
        before { run_generator %w[MyExtension --namespace=MyApp::Services] }

        it "uses custom namespace in module nesting", :aggregate_failures do
          content = file_content("app/services/application_service/extensions/my_extension/dsl.rb")
          expect(content).to include("module MyApp::Services")
          expect(content).not_to include("module ApplicationService")
        end
      end

      context "with both --path and --namespace options" do
        before { run_generator %w[MyExtension --path=lib/custom/extensions --namespace=CustomApp] }

        it "creates extension with custom path and namespace", :aggregate_failures do
          assert_file "lib/custom/extensions/my_extension/dsl.rb"

          content = file_content("lib/custom/extensions/my_extension/dsl.rb")
          expect(content).to include("module CustomApp")
          expect(content).not_to include("module ApplicationService")
        end
      end
    end

    describe "generated code validity" do
      context "with simple extension" do
        before { run_generator %w[MyExtension] }

        it_behaves_like "generates valid Ruby syntax",
                        "app/services/application_service/extensions/my_extension/dsl.rb"
      end

      context "with namespaced extension" do
        before { run_generator %w[Admin::AuditTrail] }

        it_behaves_like "generates valid Ruby syntax",
                        "app/services/application_service/extensions/admin/audit_trail/dsl.rb"
      end

      context "with custom namespace" do
        before { run_generator %w[MyExtension --namespace=MyApp::Services] }

        it_behaves_like "generates valid Ruby syntax",
                        "app/services/application_service/extensions/my_extension/dsl.rb"
      end
    end
  end
end
