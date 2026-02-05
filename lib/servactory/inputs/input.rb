# frozen_string_literal: true

module Servactory
  module Inputs
    class Input < Servactory::Maintenance::Attributes::Base
      class Actor
        attr_reader :name,
                    :internal_name,
                    :types,
                    :default,
                    :options

        def initialize(input)
          @name = input.name
          @internal_name = input.internal_name
          @types = input.types
          @default = input.default
          @options = input.options
          @attribute = input
        end

        def system_name
          @attribute.system_name
        end

        def i18n_name
          @attribute.i18n_name
        end

        def optional?
          @attribute.optional?
        end

        def required?
          @attribute.required?
        end

        # The methods below are required to support the internal work.

        def input?
          @attribute.input?
        end

        def internal?
          @attribute.internal?
        end

        def output?
          @attribute.output?
        end
      end

      attr_reader :internal_name

      # rubocop:disable Style/KeywordParametersOrder
      def initialize(
        name,
        *helpers,
        as: nil,
        option_helpers:,
        **options
      )
        @internal_name = as.presence || name

        super(name, *helpers, option_helpers:, **options)
      end
      # rubocop:enable Style/KeywordParametersOrder

      def conflict_code
        @collection_of_options.defined_conflict_code
      end

      def with_conflicts?
        conflict_code.present?
      end

      def input?
        true
      end

      private

      def available_feature_options
        {
          required: true,
          types: true,
          default: true,
          must: true,
          prepare: true
        }
      end
    end
  end
end
