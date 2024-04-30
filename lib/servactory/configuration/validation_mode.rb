# frozen_string_literal: true

module Servactory
  module Configuration
    module ValidationMode
      VALUES = %i[
        default
        bang_without_throwing_exception_for_attributes
      ].freeze

      module_function

      def decorated_values_for_error
        VALUES.map { |value| "`#{value}`" }.join(", ")
      end

      def match?(value)
        VALUES.include?(value)
      end
    end
  end
end
