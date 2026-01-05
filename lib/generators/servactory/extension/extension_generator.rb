# frozen_string_literal: true

module Servactory
  module Generators
    class ExtensionGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      class_option :path,
                   type: :string,
                   default: "app/services/application_service/extensions",
                   desc: "Path to generate extension files"

      class_option :namespace,
                   type: :string,
                   default: "ApplicationService",
                   desc: "Base namespace for the extension module"

      def create_extension
        template "extension.rb.tt", extension_file_path
      end

      private

      def extension_file_path
        "#{extensions_path}/#{file_path}/dsl.rb"
      end

      def extensions_path
        options[:path]
      end

      def base_namespace
        options[:namespace]
      end

      def extension_key
        file_path.tr("/", "_")
      end
    end
  end
end
