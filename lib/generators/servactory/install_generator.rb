# frozen_string_literal: true

require "rails/generators/base"

module Servactory
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_services
        directory "services/application_service", "app/services/application_service"
      end

      def copy_locales
        %i[en ru].each do |locale|
          copy_file "../../../../config/locales/#{locale}.yml", "config/locales/servactory.#{locale}.yml"
        end
      end
    end
  end
end
