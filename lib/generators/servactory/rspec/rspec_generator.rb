# frozen_string_literal: true

require_relative "../base"

module Servactory
  module Generators
    class RspecGenerator < Rails::Generators::NamedBase # rubocop:disable Metrics/ClassLength
      source_root File.expand_path("templates", __dir__)

      class_option :skip_validations,
                   type: :boolean,
                   default: false,
                   desc: "Skip validation examples"

      class_option :skip_pending,
                   type: :boolean,
                   default: false,
                   desc: "Skip pending placeholder"

      class_option :call_method,
                   type: :string,
                   default: "call!",
                   enum: %w[call call!],
                   desc: "Primary call method (call or call!)"

      class_option :path,
                   type: :string,
                   default: "spec/services",
                   desc: "Path to generate spec files"

      def create_spec_file
        template "service_spec.rb.tt", "#{specs_path}/#{file_path}_spec.rb"
      end

      private

      def specs_path
        options[:path]
      end

      def skip_validations?
        options[:skip_validations]
      end

      def skip_pending?
        options[:skip_pending]
      end

      def call_method
        options[:call_method]
      end

      def service_class
        @service_class ||= class_name.constantize
      rescue NameError
        nil
      end

      def service_info
        @service_info ||= service_class&.info
      end

      def service_exists?
        service_class.present? && service_info.present?
      end

      def inputs_from_info # rubocop:disable Metrics/MethodLength
        return [] unless service_info

        service_info.inputs.map do |name, data|
          types = data[:types] || []
          {
            name:,
            types:,
            type_string: format_types(types),
            required: data[:required] != false,
            default: data[:default],
            example: example_value_for_types(types)
          }
        end
      end

      def internals_from_info
        return [] unless service_info

        service_info.internals.map do |name, data|
          types = data[:types] || []
          {
            name:,
            types:,
            type_string: format_types(types)
          }
        end
      end

      def outputs_from_info
        return [] unless service_info

        service_info.outputs.map do |name, data|
          types = data[:types] || []
          {
            name:,
            types:,
            type_string: format_types(types)
          }
        end
      end

      def format_types(types)
        return "String" if types.empty?

        if types.size == 1
          types.first.to_s
        else
          "[#{types.map(&:to_s).join(', ')}]"
        end
      end

      def example_value_for_types(types) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        return '"Some value"' if types.empty?

        type = types.first.to_s
        case type
        when "Integer" then "1"
        when "Float" then "1.0"
        when "TrueClass" then "true"
        when "FalseClass" then "false"
        when "Array" then "[]"
        when "Hash" then "{}"
        when "Symbol" then ":example"
        when "Date" then "Date.current"
        when "DateTime" then "DateTime.current"
        when "Time" then "Time.current"
        when "NilClass" then "nil"
        else
          '"Some value"'
        end
      end
    end
  end
end
