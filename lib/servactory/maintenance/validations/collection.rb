# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Collection
        def self.validate(...)
          new(...).validate
        end

        def initialize(value:, types:, type:)
          @value = value
          @types = types
          @type = type

          @valid = false
        end

        def validate
          @valid = @value.is_a?(@types.fetch(0, Array)) && @value.respond_to?(:all?) && @value.all?(@type)

          self
        end

        def valid?
          @valid
        end
      end
    end
  end
end
