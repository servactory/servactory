# frozen_string_literal: true

require_relative "../base"

module Servactory
  module Generators
    class RspecGenerator < Servactory::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :inputs, type: :array, default: [], banner: "name:type"

      class_option :call_method,
                   type: :string,
                   default: "call!",
                   enum: %w[call call!],
                   desc: "Primary call method (call or call!)"

      class_option :path,
                   type: :string,
                   default: "app/services",
                   desc: "Path to service files (specs auto-generated to spec/...)"

      class_option :skip_pending,
                   type: :boolean,
                   default: false,
                   desc: "Skip pending placeholder"

      def create_spec_file
        template "service_spec.rb.tt", spec_file_path
      end

      private

      def spec_file_path
        "#{specs_path}/#{file_path}_spec.rb"
      end

      def specs_path
        # Convert services path to specs path:
        # app/services → spec/services
        # lib/foo → spec/foo
        # engines/core/app/services → engines/core/spec/services
        # engines/admin/lib/services → engines/admin/spec/services
        path = services_path

        # Handle Rails engine paths first
        if path.match?(%r{^engines/[^/]+/app/})
          return path.sub(%r{/app/}, "/spec/")
        end

        if path.match?(%r{^engines/[^/]+/lib/})
          return path.sub(%r{/lib/}, "/spec/")
        end

        # Standard app/ and lib/ paths
        path
          .sub(%r{^app/}, "spec/")
          .sub(%r{^lib/}, "spec/")
      end

      def services_path
        options[:path]
      end

      def call_method
        options[:call_method]
      end

      def skip_pending?
        options[:skip_pending]
      end

      def inputs_with_examples
        parsed_inputs.map do |input|
          input.merge(example: example_value_for_type(input[:type]))
        end
      end

      def example_value_for_type(type_string) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        case type_string
        when "Integer" then "1"
        when "Float" then "1.0"
        when "TrueClass", "[TrueClass, FalseClass]" then "true"
        when "FalseClass" then "false"
        when "Array" then "[]"
        when "Hash" then "{}"
        when "Symbol" then ":example"
        when "Date" then "Date.current"
        when "DateTime" then "DateTime.current"
        when "Time" then "Time.current"
        when "NilClass" then "nil"
        when "BigDecimal" then 'BigDecimal("1.0")'
        else
          '"Some value"'
        end
      end
    end
  end
end
