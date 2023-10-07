# frozen_string_literal: true

module Servactory
  module Inputs
    class OptionsCollection
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
          option_body = if option.body.is_a?(Hash)
                          option.body.key?(:is) ? option.body.fetch(:is) : option.body
                        else
                          option.body
                        end

          [option.name, option_body]
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
