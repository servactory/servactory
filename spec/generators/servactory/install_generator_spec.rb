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
    context "with default options" do
      before { run_generator }

      it "creates base.rb", :aggregate_failures do
        assert_file "app/services/application_service/base.rb"

        content = file_content("app/services/application_service/base.rb")
        expect(content).to include("module ApplicationService")
        expect(content).to include("class Base < Servactory::Base")
        expect(content).to include("failure_class ApplicationService::Exceptions::Failure")
      end

      it "creates exceptions.rb", :aggregate_failures do
        assert_file "app/services/application_service/exceptions.rb"

        content = file_content("app/services/application_service/exceptions.rb")
        expect(content).to include("module ApplicationService")
        expect(content).to include("module Exceptions")
        expect(content).to include("class Failure < Servactory::Exceptions::Failure")
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

    context "with --namespace option" do
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

    context "with --path option" do
      before { run_generator %w[--path=lib/my_gem/services] }

      it "creates files in custom path", :aggregate_failures do
        assert_file "lib/my_gem/services/application_service/base.rb"
        assert_file "lib/my_gem/services/application_service/exceptions.rb"
        assert_file "lib/my_gem/services/application_service/result.rb"
        assert_file "lib/my_gem/services/application_service/dynamic_options/.keep"
        assert_file "lib/my_gem/services/application_service/extensions/.keep"

        assert_no_file "app/services/application_service/base.rb"
      end
    end

    context "with --path and --namespace options" do
      before { run_generator %w[--path=lib/my_gem/services --namespace=MyApp::Services] }

      it "creates files in custom path with custom namespace", :aggregate_failures do
        assert_file "lib/my_gem/services/my_app/services/base.rb"
        assert_file "lib/my_gem/services/my_app/services/exceptions.rb"
        assert_file "lib/my_gem/services/my_app/services/result.rb"
      end
    end

    context "with --minimal option" do
      before { run_generator %w[--minimal] }

      it "creates base.rb without configuration examples", :aggregate_failures do
        content = file_content("app/services/application_service/base.rb")
        expect(content).not_to include("More information:")
        expect(content).not_to include("# input_option_helpers")
      end
    end
  end

  describe "#copy_locales" do
    context "with default options" do
      before { run_generator }

      it "does not copy any locale files", :aggregate_failures do
        assert_no_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.es.yml"
        assert_no_file "config/locales/servactory.it.yml"
      end
    end

    context "with --locales=en" do
      before { run_generator %w[--locales=en] }

      it "copies only English locale file", :aggregate_failures do
        assert_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.es.yml"
        assert_no_file "config/locales/servactory.it.yml"
      end
    end

    context "with --locales=en,ru" do
      before { run_generator %w[--locales=en,ru] }

      it "copies only English and Russian locale files", :aggregate_failures do
        assert_file "config/locales/servactory.en.yml"
        assert_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.es.yml"
        assert_no_file "config/locales/servactory.it.yml"
      end
    end

    context "with --locales=de" do
      before { run_generator %w[--locales=de] }

      it "copies only German locale file", :aggregate_failures do
        assert_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.es.yml"
        assert_no_file "config/locales/servactory.it.yml"
      end
    end

    context "with --locales=fr" do
      before { run_generator %w[--locales=fr] }

      it "copies only French locale file", :aggregate_failures do
        assert_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.es.yml"
        assert_no_file "config/locales/servactory.it.yml"
      end
    end

    context "with --locales=es" do
      before { run_generator %w[--locales=es] }

      it "copies only Spanish locale file", :aggregate_failures do
        assert_file "config/locales/servactory.es.yml"
        assert_no_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.it.yml"
      end
    end

    context "with --locales=it" do
      before { run_generator %w[--locales=it] }

      it "copies only Italian locale file", :aggregate_failures do
        assert_file "config/locales/servactory.it.yml"
        assert_no_file "config/locales/servactory.en.yml"
        assert_no_file "config/locales/servactory.ru.yml"
        assert_no_file "config/locales/servactory.de.yml"
        assert_no_file "config/locales/servactory.fr.yml"
        assert_no_file "config/locales/servactory.es.yml"
      end
    end

    context "with all locales" do
      before { run_generator %w[--locales=en,ru,de,fr,es,it] }

      it "copies all locale files", :aggregate_failures do
        %w[en ru de fr es it].each do |locale|
          assert_file "config/locales/servactory.#{locale}.yml"
        end
      end
    end
  end

  describe "namespace validation" do
    context "with invalid namespace names" do
      it "rejects namespace starting with lowercase" do
        expect { run_generator %w[--namespace=myApp] }.to raise_error(ArgumentError, /Invalid namespace/)
      end

      it "rejects namespace starting with number" do
        expect { run_generator %w[--namespace=123Service] }.to raise_error(ArgumentError, /Invalid namespace/)
      end

      it "rejects namespace with spaces" do
        expect { run_generator ["--namespace=My App"] }.to raise_error(ArgumentError, /Invalid namespace/)
      end

      it "rejects namespace with special characters" do
        expect { run_generator %w[--namespace=My-Service] }.to raise_error(ArgumentError, /Invalid namespace/)
      end

      it "rejects empty namespace" do
        expect { run_generator %w[--namespace=] }.to raise_error(ArgumentError, /Invalid namespace/)
      end
    end

    context "with valid namespace names" do
      it "accepts simple namespace" do
        expect { run_generator %w[--namespace=MyService] }.not_to raise_error
        assert_file "app/services/my_service/base.rb"
      end

      it "accepts nested namespace" do
        expect { run_generator %w[--namespace=MyApp::Services] }.not_to raise_error
        assert_file "app/services/my_app/services/base.rb"
      end

      it "accepts deeply nested namespace" do
        expect { run_generator %w[--namespace=MyCompany::MyApp::Core::Services] }.not_to raise_error
        assert_file "app/services/my_company/my_app/core/services/base.rb"
      end
    end
  end

  describe "generated code validity" do
    context "with default options" do
      before { run_generator }

      it_behaves_like "generates valid Ruby syntax", "app/services/application_service/base.rb"
      it_behaves_like "generates valid Ruby syntax", "app/services/application_service/exceptions.rb"
      it_behaves_like "generates valid Ruby syntax", "app/services/application_service/result.rb"
    end

    context "with custom namespace" do
      before { run_generator %w[--namespace=MyApp::Services] }

      it_behaves_like "generates valid Ruby syntax", "app/services/my_app/services/base.rb"
      it_behaves_like "generates valid Ruby syntax", "app/services/my_app/services/exceptions.rb"
      it_behaves_like "generates valid Ruby syntax", "app/services/my_app/services/result.rb"
    end

    context "with minimal option" do
      before { run_generator %w[--minimal] }

      it_behaves_like "generates valid Ruby syntax", "app/services/application_service/base.rb"
    end
  end
end
