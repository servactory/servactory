# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class OptionsCollection
        extend Forwardable

        def_delegators :@collection, :<<, :filter, :each, :map, :flat_map, :find, :empty?, :size

        def initialize
          @collection = Set.new
        end

        def names
          map(&:name)
        end

        def validation_classes
          @validation_classes ||=
            filter { |option| option.validation_class.present? }
            .map(&:validation_class)
            .uniq
        end

        def options_for_checks
          filter(&:need_for_checks?).to_h do |option|
            [option.name, extract_normalized_body_from(option:)]
          end
        end

        def defined_conflict_code
          flat_map { |option| resolve_conflicts_from(option:) }
            .reject(&:blank?)
            .first
        end

        def find_by(name:)
          find { |option| option.name == name }
        end

        private

        def extract_normalized_body_from(option:)
          body = option.body
          return body unless body.is_a?(Hash)

          body.key?(:is) ? body.fetch(:is) : body
        end

        def resolve_conflicts_from(option:)
          return [] unless option.define_conflicts

          option.define_conflicts.map { |conflict| conflict.content.call }
        end
      end
    end
  end
end
