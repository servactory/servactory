# frozen_string_literal: true

module Servactory
  module Internals
    class Internal < Servactory::Attributes::Base
      class Actor
        attr_reader :name,
                    :types,
                    :options

        def initialize(internal)
          @name = internal.name
          @types = internal.types
          @options = internal.options
          @attribute = internal
        end

        def system_name
          @attribute.system_name
        end

        def i18n_name
          @attribute.i18n_name
        end

        def input?
          false
        end

        def internal?
          true
        end

        def output?
          false
        end
      end

      def internal?
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
