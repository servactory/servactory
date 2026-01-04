# frozen_string_literal: true

require_relative "../base"

module Servactory
  module Generators
    class RspecGenerator < Servactory::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "input:type"

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

      def create_spec_file
        template "service_spec.rb.tt", "spec/services/#{file_path}_spec.rb"
      end

      private

      def skip_validations?
        options[:skip_validations]
      end

      def skip_pending?
        options[:skip_pending]
      end

      def call_method
        options[:call_method]
      end

      def example_value_for(type)
        case type
        when "Integer" then "1"
        when "Float" then "1.0"
        when "TrueClass", "Boolean" then "true"
        when "FalseClass" then "false"
        when "Array" then "[]"
        when "Hash" then "{}"
        when "Symbol" then ":example"
        when "Date" then "Date.current"
        when "DateTime" then "DateTime.current"
        when "Time" then "Time.current"
        else
          '"Some value"'
        end
      end

      def inputs_with_examples
        parsed_inputs.map do |input|
          {
            name: input[:name],
            type: input[:type],
            example: example_value_for(input[:type])
          }
        end
      end
    end
  end
end
