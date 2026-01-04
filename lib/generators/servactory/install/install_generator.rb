# frozen_string_literal: true

require_relative "../base"

module Servactory
  module Generators
    class InstallGenerator < Servactory::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :locales,
                   type: :array,
                   default: [],
                   desc: "Locales to install (e.g., --locales=en ru)"

      class_option :skip_comments,
                   type: :boolean,
                   default: false,
                   desc: "Skip configuration comments"

      class_option :namespace,
                   type: :string,
                   default: "ApplicationService",
                   desc: "Base namespace for services"

      def create_application_service
        template "application_service/base.rb.tt", service_path("base.rb")
        template "application_service/exceptions.rb.tt", service_path("exceptions.rb")
        template "application_service/result.rb.tt", service_path("result.rb")

        create_file service_path("dynamic_options/.keep"), ""
        create_file service_path("extensions/.keep"), ""
      end

      def copy_locales
        return if options[:locales].blank?

        options[:locales].each do |locale|
          locale_file = "servactory.#{locale}.yml"
          source_file = "locales/#{locale_file}"

          if File.exist?(File.join(self.class.source_root, source_file))
            copy_file source_file, "config/locales/#{locale_file}"
          else
            say "Locale file not found: #{locale_file}", :yellow
          end
        end
      end

      private

      def namespace
        options[:namespace]
      end

      def namespace_path
        namespace.underscore
      end

      def service_path(filename)
        "app/services/#{namespace_path}/#{filename}"
      end

      def skip_comments?
        options[:skip_comments]
      end
    end
  end
end
