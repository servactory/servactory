# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          # Concern providing accessor methods for attribute data in submatchers.
          #
          # ## Purpose
          #
          # AttributeDataAccess provides convenient methods for submatchers to access
          # attribute definition data from the context. This includes the service class,
          # attribute metadata, and helper methods for fetching specific options.
          #
          # ## Usage
          #
          # Include in submatcher classes:
          #
          # ```ruby
          # class MySubmatcher < Base::Submatcher
          #   include Concerns::AttributeDataAccess
          #
          #   def passes?
          #     # Access attribute data directly
          #     fetch_option(:required) == true
          #   end
          # end
          # ```
          #
          # ## Methods Provided
          #
          # - `described_class` - the service class being tested
          # - `attribute_type` - :input, :internal, or :output
          # - `attribute_name` - name of the attribute
          # - `attribute_data` - full attribute definition hash
          # - `fetch_option` - get specific option from attribute data
          # - `option_present?` - check if option exists and has value
          module AttributeDataAccess
            # Includes InstanceMethods in the including class.
            #
            # @param base [Class] The class including this concern
            # @return [void]
            def self.included(base)
              base.include(InstanceMethods)
            end

            # Instance methods added by this concern.
            module InstanceMethods
              # @return [Class, nil] The Servactory service class from context
              def described_class = context&.described_class

              # @return [Symbol, nil] The attribute type from context
              def attribute_type = context&.attribute_type

              # @return [Symbol, nil] The attribute name from context
              def attribute_name = context&.attribute_name

              # @return [Symbol, nil] The pluralized attribute type from context
              def attribute_type_plural = context&.attribute_type_plural

              # @return [String, nil] The i18n root key from context
              def i18n_root_key = context&.i18n_root_key

              # Returns the attribute definition data hash.
              #
              # @return [Hash] The attribute data from context
              def attribute_data
                context.attribute_data
              end

              # Fetches a specific option from attribute data.
              #
              # @param key [Symbol] The option key to fetch
              # @param default [Object, nil] Default value if key not present
              # @return [Object] The option value or default
              def fetch_option(key, default = nil)
                attribute_data.fetch(key, default)
              end

              # Checks if an option is present and has a meaningful value.
              #
              # Returns false if the key doesn't exist, or if the value is nil
              # or empty (for collections).
              #
              # @param key [Symbol] The option key to check
              # @return [Boolean] True if option exists with non-empty value
              def option_present?(key)
                return false unless attribute_data.key?(key)

                value = attribute_data[key]
                !value.nil? && (!value.respond_to?(:empty?) || !value.empty?)
              end
            end
          end
        end
      end
    end
  end
end
