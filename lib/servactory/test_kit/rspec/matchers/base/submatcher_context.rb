# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          # Data transfer object carrying context for submatcher validation.
          #
          # ## Purpose
          #
          # SubmatcherContext encapsulates all the information a submatcher needs
          # to perform its validation. It provides a clean interface for passing
          # attribute metadata, service class info, and dependent data between
          # the parent matcher and individual submatchers.
          #
          # ## Usage
          #
          # Created by AttributeMatcher and passed to each submatcher:
          #
          # ```ruby
          # context = SubmatcherContext.new(
          #   described_class: MyService,
          #   attribute_type: :input,
          #   attribute_name: :user_id,
          #   attribute_data: { type: Integer, required: true }
          # )
          #
          # submatcher = RequiredSubmatcher.new(context)
          # ```
          #
          # ## Attributes
          #
          # - `described_class` - The Servactory service class being tested
          # - `attribute_type` - :input, :internal, or :output
          # - `attribute_name` - Name of the attribute being validated
          # - `attribute_data` - Hash with attribute definition (type, required, etc.)
          # - `option_types` - Type classes passed via .type() chain method
          # - `last_submatcher` - Previous submatcher (for dependent validations)
          # - `i18n_root_key` - Root key for i18n error messages
          class SubmatcherContext
            # @return [Class] The Servactory service class being tested
            attr_reader :described_class

            # @return [Symbol] The attribute type (:input, :internal, :output)
            attr_reader :attribute_type

            # @return [Symbol] The name of the attribute being validated
            attr_reader :attribute_name

            # @return [Hash] The attribute definition data from service info
            attr_reader :attribute_data

            # @return [Array, nil] Type classes from the .type() chain method
            attr_reader :option_types

            # @return [Submatcher, nil] The previous submatcher for chained validations
            attr_reader :last_submatcher

            # @return [String, nil] The i18n root key for error messages
            attr_reader :i18n_root_key

            # Creates a new submatcher context.
            #
            # @param described_class [Class] The Servactory service class
            # @param attribute_type [Symbol] The attribute type (:input, :internal, :output)
            # @param attribute_name [Symbol] The attribute name
            # @param attribute_data [Hash] The attribute definition data
            # @param option_types [Array, nil] Type classes from .type() method
            # @param last_submatcher [Submatcher, nil] Previous submatcher for chaining
            # @param i18n_root_key [String, nil] Root key for i18n messages
            def initialize(
              described_class:,
              attribute_type:,
              attribute_name:,
              attribute_data:,
              option_types: nil,
              last_submatcher: nil,
              i18n_root_key: nil
            )
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_name = attribute_name
              @attribute_data = attribute_data
              @option_types = option_types
              @last_submatcher = last_submatcher
              @i18n_root_key = i18n_root_key
            end

            # Returns the pluralized attribute type for accessing service info.
            #
            # @return [Symbol] Pluralized type (:inputs, :internals, :outputs)
            def attribute_type_plural
              @attribute_type_plural ||= attribute_type.to_s.pluralize.to_sym
            end
          end
        end
      end
    end
  end
end
