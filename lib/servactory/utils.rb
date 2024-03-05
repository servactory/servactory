# frozen_string_literal: true

module Servactory
  module Utils
    module_function

    def fetch_hash_with_desired_attribute(attribute)
      if attribute.input?
        { input: attribute.class::Work.new(attribute) }
      elsif attribute.internal?
        { internal: attribute.class::Work.new(attribute) }
      elsif attribute.output?
        { output: attribute.class::Work.new(attribute) }
      end
    end

    def define_attribute_with(input:, internal:, output:)
      return input if input.present? && input.input?
      return internal if internal.present? && internal.internal?
      return output if output.present? && output.output?

      raise ArgumentError, "missing keyword: :input, :internal or :output"
    end

    FALSE_VALUES = [
      false,
      nil, "",
      "0", :"0", 0,
      "f", :f,
      "F", :F,
      "false", :false, # rubocop:disable Lint/BooleanSymbol
      "FALSE", :FALSE,
      "off", :off,
      "OFF", :OFF
    ].to_set.freeze

    private_constant :FALSE_VALUES

    # @param value [#to_s]
    # @return [Boolean]
    def true?(value)
      !FALSE_VALUES.include?(value)
    end

    # @param value [#to_s]
    # @return [Boolean]
    def value_present?(value)
      !value.nil? && (
        value.respond_to?(:empty?) ? !value.empty? : true
      )
    end

    # NOTE: Based on `query_cast_attribute` from ActiveRecord:
    #       https://github.com/rails/rails/blob/main/activerecord/lib/active_record/attribute_methods/query.rb
    # @param value [#to_s]
    # @return [Boolean]
    def query_attribute(value) # rubocop:disable Metrics/MethodLength
      case value
      when true        then true
      when false, nil  then false
      else
        if value.is_a?(Numeric) || (value.respond_to?(:match?) && !value.match?(/[^0-9]/))
          !value.to_i.zero?
        else
          return false if FALSE_VALUES.include?(value)

          !value.blank?
        end
      end
    end
  end
end
