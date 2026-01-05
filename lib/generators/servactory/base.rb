# frozen_string_literal: true

require "rails/generators/base"
require "rails/generators/named_base"

module Servactory
  module Generators
    class Base < Rails::Generators::Base
      def self.gem_root
        @gem_root ||= File.expand_path("../../..", __dir__)
      end

      def self.gem_locales_path
        @gem_locales_path ||= File.join(gem_root, "config", "locales")
      end

      private

      def gem_root
        self.class.gem_root
      end

      def gem_locales_path
        self.class.gem_locales_path
      end
    end

    class NamedBase < Rails::Generators::NamedBase
      VALID_INPUT_NAME_REGEX = /\A[a-z_][a-zA-Z0-9_]*\z/

      TYPE_MAPPING = {
        "string" => "String",
        "integer" => "Integer",
        "float" => "Float",
        "boolean" => "[TrueClass, FalseClass]",
        "bool" => "[TrueClass, FalseClass]",
        "array" => "Array",
        "hash" => "Hash",
        "symbol" => "Symbol",
        "date" => "Date",
        "datetime" => "DateTime",
        "time" => "Time",
        "nil" => "NilClass",
        "nilclass" => "NilClass",
        "decimal" => "BigDecimal",
        "bigdecimal" => "BigDecimal"
      }.freeze

      private

      def input_names
        @input_names ||= parsed_inputs.map { |input| input[:name] }
      end

      def parsed_inputs
        @parsed_inputs ||= inputs.map do |input_argument|
          parts = input_argument.to_s.split(":", 2)
          name = parts[0].strip
          type = normalize_type(parts[1])

          validate_input_name!(name)

          { name:, type: }
        end
      end

      def validate_input_name!(name)
        return if name.match?(VALID_INPUT_NAME_REGEX)

        raise ArgumentError, "Invalid input name '#{name}'. " \
                             "Input names must start with a lowercase letter or underscore, " \
                             "followed by letters, numbers, or underscores."
      end

      def normalize_type(type_string)
        return "String" if type_string.blank?

        TYPE_MAPPING[type_string.downcase] || type_string
      end
    end
  end
end
