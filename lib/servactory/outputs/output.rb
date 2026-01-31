# frozen_string_literal: true

module Servactory
  module Outputs
    class Output < Servactory::Attributes::Base
      class Actor
        attr_reader :name,
                    :types,
                    :options

        def initialize(output)
          @name = output.name
          @types = output.types
          @options = output.options
          @attribute = output
        end

        def system_name
          @attribute.system_name
        end

        def i18n_name
          @attribute.i18n_name
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

      def output?
        true
      end

      private

      def available_feature_options
        {
          types: true,
          must: true
        }
      end
    end
  end
end
