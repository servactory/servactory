# frozen_string_literal: true

require_relative "../base"

module Servactory
  module Generators
    class ServiceGenerator < Servactory::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "input:type"

      class_option :base_class,
                   type: :string,
                   default: "ApplicationService::Base",
                   desc: "Base class for the service"

      class_option :skip_output,
                   type: :boolean,
                   default: false,
                   desc: "Skip default output declaration"

      def create_service
        template "service.rb.tt", "app/services/#{file_path}.rb"
      end

      private

      def base_class
        options[:base_class]
      end

      def skip_output?
        options[:skip_output]
      end

      def input_declarations
        parsed_inputs.map do |input|
          "input :#{input[:name]}, type: #{input[:type]}"
        end
      end
    end
  end
end
