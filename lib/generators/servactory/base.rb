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
      TYPE_MAPPING = {
        "string" => "String",
        "integer" => "Integer",
        "float" => "Float",
        "boolean" => "TrueClass",
        "bool" => "TrueClass",
        "array" => "Array",
        "hash" => "Hash",
        "symbol" => "Symbol",
        "date" => "Date",
        "datetime" => "DateTime",
        "time" => "Time"
      }.freeze

      private

      def input_names
        @input_names ||= attributes_names
      end

      def parsed_inputs
        @parsed_inputs ||= attributes.map do |attr|
          name = attr.name
          type = normalize_type(attr.type&.to_s)

          { name: name, type: type }
        end
      end

      def normalize_type(type_string)
        return "String" if type_string.blank?

        TYPE_MAPPING[type_string.downcase] || type_string
      end
    end
  end
end
