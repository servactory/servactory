# frozen_string_literal: true

module Servactory
  module Utils
    extend self

    def adapt_datory(data)
      if defined?(Datory::Base) && data.is_a?(Datory::Base) # rubocop:disable Style/IfUnlessModifier
        return Servactory::Utils.send(:instance_variables_to_hash_from, data)
      end

      data
    end

    def fetch_hash_with_desired_attribute(attribute)
      return { input: attribute.class::Actor.new(attribute) } if really_input?(attribute)
      return { internal: attribute.class::Actor.new(attribute) } if really_internal?(attribute)
      return { output: attribute.class::Actor.new(attribute) } if really_output?(attribute)

      raise ArgumentError, "Failed to define attribute"
    end

    def define_attribute_with(input: nil, internal: nil, output: nil)
      return input if really_input?(input)
      return internal if really_internal?(internal)
      return output if really_output?(output)

      raise ArgumentError, "missing keyword: :input, :internal or :output"
    end

    def really_input?(attribute = nil)
      return true if attribute.present? && attribute.input?

      false
    end

    def really_internal?(attribute = nil)
      return true if attribute.present? && attribute.internal?

      false
    end

    def really_output?(attribute = nil)
      return true if attribute.present? && attribute.output?

      false
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

    def constantize_class(class_or_name)
      case class_or_name
      when String, Symbol
        begin
          Object.const_get(class_or_name)
        rescue NameError
          class_or_name.safe_constantize
        end
      else
        class_or_name
      end
    end

    private

    def instance_variables_to_hash_from(data) # rubocop:disable Metrics/MethodLength
      data.instance_variables.to_h do |key|
        value = data.instance_variable_get(key)

        value =
          if value.is_a?(Set) || value.is_a?(Array)
            value.map { |item| instance_variables_to_hash_from(item) }
          elsif value.is_a?(Datory::Base)
            instance_variables_to_hash_from(value)
          else
            value
          end

        [key.to_s.delete_prefix("@").to_sym, value]
      end
    end
  end
end
