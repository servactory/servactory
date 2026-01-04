# frozen_string_literal: true

require "spec_helper"

INSTALL_GENERATOR_AVAILABLE = begin
  require "generators/servactory/install/install_generator"
  true
rescue LoadError
  false
end

RSpec.describe "Servactory::Generators::InstallGenerator", skip: !INSTALL_GENERATOR_AVAILABLE do
  include GeneratorHelpers

  tests Servactory::Generators::InstallGenerator if INSTALL_GENERATOR_AVAILABLE

  describe "#create_application_service" do
    before { run_generator }

    it "creates base.rb", :aggregate_failures do
      assert_file "app/services/application_service/base.rb"

      content = file_content("app/services/application_service/base.rb")
      expect(content).to include("module ApplicationService")
      expect(content).to include("class Base < Servactory::Base")
      expect(content).to include("success_class ApplicationService::Exceptions::Success")
    end

    it "creates exceptions.rb", :aggregate_failures do
      assert_file "app/services/application_service/exceptions.rb"

      content = file_content("app/services/application_service/exceptions.rb")
      expect(content).to include("module ApplicationService")
      expect(content).to include("module Exceptions")
      expect(content).to include("class Success < Servactory::Exceptions::Success")
    end

    it "creates result.rb", :aggregate_failures do
      assert_file "app/services/application_service/result.rb"

      content = file_content("app/services/application_service/result.rb")
      expect(content).to include("module ApplicationService")
      expect(content).to include("class Result")
    end

    it "creates .keep files for empty directories", :aggregate_failures do
      assert_file "app/services/application_service/dynamic_options/.keep"
      assert_file "app/services/application_service/extensions/.keep"
    end
  end

  describe "#create_application_service with --namespace option" do
    before { run_generator %w[--namespace=MyApp::Services] }

    it "uses custom namespace path", :aggregate_failures do
      assert_file "app/services/my_app/services/base.rb"
      assert_file "app/services/my_app/services/exceptions.rb"
      assert_file "app/services/my_app/services/result.rb"
    end

    it "uses custom namespace in content", :aggregate_failures do
      content = file_content("app/services/my_app/services/base.rb")
      expect(content).to include("module MyApp::Services")
      expect(content).to include("MyApp::Services::Exceptions::Input")
    end
  end

  describe "#create_application_service with --minimal option" do
    before { run_generator %w[--minimal] }

    it "creates base.rb without configuration examples", :aggregate_failures do
      content = file_content("app/services/application_service/base.rb")
      expect(content).not_to include("More information:")
      expect(content).not_to include("# input_option_helpers")
    end
  end

  describe "#copy_locales" do
    context "without --locales option" do
      before { run_generator }

      it "does not copy any locale files", :aggregate_failures do
        assert_no_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
      end
    end

    context "with --locales=en" do
      before { run_generator %w[--locales=en] }

      it "copies only English locale file", :aggregate_failures do
        assert_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
      end
    end

    context "with multiple locales" do
      before { run_generator %w[--locales=en,ru] }

      it "copies both locale files", :aggregate_failures do
        assert_file "config/locales/servactory.en.yml"
        assert_file "config/locales/servactory.ru.yml"
      end
    end
  end
end
