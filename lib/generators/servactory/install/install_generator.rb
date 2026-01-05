# frozen_string_literal: true

require_relative "../base"

module Servactory
  module Generators
    class InstallGenerator < Servactory::Generators::Base
      source_root File.expand_path("templates", __dir__)

      VALID_NAMESPACE_REGEX = /\A[A-Z][a-zA-Z0-9_]*(::[A-Z][a-zA-Z0-9_]*)*\z/

      class_option :namespace,
                   type: :string,
                   default: "ApplicationService",
                   desc: "Base namespace for services"

      class_option :path,
                   type: :string,
                   default: "app/services",
                   desc: "Path to install service files"

      class_option :locales,
                   type: :array,
                   default: [],
                   desc: "Locales to install (e.g., --locales=en,ru)"

      class_option :minimal,
                   type: :boolean,
                   default: false,
                   desc: "Generate minimal setup without configuration examples"

      def create_application_service
        validate_namespace!

        template "application_service/base.rb.tt", service_path("base.rb")
        template "application_service/exceptions.rb.tt", service_path("exceptions.rb")
        template "application_service/result.rb.tt", service_path("result.rb")

        create_file service_path("dynamic_options/.keep"), ""
        create_file service_path("extensions/.keep"), ""
      end

      def copy_locales
        return if locales.blank?

        locales.each do |locale|
          locale_file = "servactory.#{locale}.yml"
          source_path = File.join(gem_locales_path, "#{locale}.yml")

          if File.exist?(source_path)
            copy_file source_path, "config/locales/#{locale_file}"
          else
            say "Locale file not found: #{locale} (expected at #{source_path})", :yellow
          end
        end
      end

      private

      def validate_namespace!
        return if namespace.match?(VALID_NAMESPACE_REGEX)

        raise ArgumentError, "Invalid namespace '#{namespace}'. " \
                             "Namespace must be a valid Ruby constant name " \
                             "(e.g., 'ApplicationService', 'MyApp::Services')."
      end

      def namespace
        options[:namespace]
      end

      def namespace_path
        namespace.underscore
      end

      def base_path
        options[:path]
      end

      def service_path(filename)
        "#{base_path}/#{namespace_path}/#{filename}"
      end

      def locales
        # Handle both "--locales=en,ru" (single string) and "--locales en ru" (array)
        options[:locales].flat_map { |locale| locale.split(",") }
      end

      def minimal?
        options[:minimal]
      end
    end
  end
end
