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

      class_option :skip_make,
                   type: :boolean,
                   default: false,
                   desc: "Skip default make method"

      class_option :internal,
                   type: :array,
                   default: [],
                   desc: "Internal attributes (e.g., --internal=cache data)"

      class_option :output,
                   type: :array,
                   default: [],
                   desc: "Output attributes (e.g., --output=result status)"

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

      def skip_make?
        options[:skip_make]
      end

      def internal_attributes
        options[:internal]
      end

      def output_attributes
        options[:output].presence || (skip_output? ? [] : ["result"])
      end

      def input_declarations
        parsed_inputs.map do |input|
          "input :#{input[:name]}, type: #{input[:type]}"
        end
      end

      def internal_declarations
        internal_attributes.map do |attr|
          "internal :#{attr}, type: String"
        end
      end

      def output_declarations
        output_attributes.map do |attr|
          "output :#{attr}, type: Symbol"
        end
      end
    end
  end
end
