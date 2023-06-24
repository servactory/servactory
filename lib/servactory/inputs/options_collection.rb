# frozen_string_literal: true

module Servactory
  module Inputs
    class OptionsCollection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :flat_map, :find

      def initialize(*)
        @collection = Set.new
      end

      def names
        map(&:name)
      end

      def validation_classes
        filter { |option| option.validation_class.present? }.map(&:validation_class).uniq
      end

      def options_for_checks
        filter(&:need_for_checks?).to_h do |option|
          value = if option.value.is_a?(Hash)
                    option.value.key?(:is) ? option.value.fetch(:is) : option.value
                  else
                    option.value
                  end

          [option.name, value]
        end
      end

      def defined_conflict_code
        flat_map do |option|
          option.define_input_conflicts&.map do |define_input_conflict|
            define_input_conflict.content.call
          end
        end.reject(&:blank?).first
      end

      def find_by(name:)
        find { |option| option.name == name }
      end
    end
  end
end
