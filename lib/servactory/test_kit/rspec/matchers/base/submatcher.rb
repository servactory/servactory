# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          # Abstract base class for individual validation rules in attribute matchers.
          #
          # ## Purpose
          #
          # Submatcher provides the foundation for specific validation checks like
          # type validation, required/optional status, default values, etc.
          # Each submatcher validates one aspect of a service attribute definition.
          #
          # ## Usage
          #
          # Create a subclass and implement required abstract methods:
          #
          # ```ruby
          # class RequiredSubmatcher < Base::Submatcher
          #   def description
          #     "required"
          #   end
          #
          #   protected
          #
          #   def passes?
          #     fetch_option(:required) == true
          #   end
          #
          #   def build_failure_message
          #     "expected input to be required, but it was optional"
          #   end
          # end
          # ```
          #
          # ## Abstract Methods
          #
          # Subclasses must implement:
          # - `description` - human-readable description for test output
          # - `passes?` - validation logic returning boolean
          # - `build_failure_message` - explanation when validation fails
          #
          # ## Architecture
          #
          # Works with:
          # - SubmatcherContext - provides attribute data and metadata
          # - AttributeMatcher - manages collection of submatchers
          # - Concerns - provides helper methods for data access and comparison
          class Submatcher
            include RSpec::Matchers::Composable
            include Concerns::AttributeDataAccess
            include Concerns::ErrorMessageBuilder
            include Concerns::ValueComparison

            # @return [String] Failure message when validation does not pass
            attr_reader :missing_option

            # Creates a new submatcher instance.
            #
            # @param context [SubmatcherContext] Context with attribute data and metadata
            def initialize(context)
              @context = context
              @missing_option = ""
            end

            # Checks if this submatcher's validation passes.
            #
            # @param _subject [Object] RSpec subject (unused, kept for interface compatibility)
            # @return [Boolean] True if validation passes
            def matches?(_subject)
              if passes?
                true
              else
                @missing_option = build_failure_message
                false
              end
            end

            # Returns the failure message for RSpec output.
            #
            # @return [String] The failure message
            def failure_message
              @missing_option
            end

            # Returns the failure message for negated expectations.
            #
            # @return [String] The negated failure message
            def failure_message_when_negated
              "expected not to #{description}"
            end

            # Returns a human-readable description of what this submatcher validates.
            #
            # @abstract Subclasses must implement this method
            # @return [String] Description for test output
            # @raise [NotImplementedError] If not implemented by subclass
            def description
              raise NotImplementedError, "#{self.class} must implement #description"
            end

            protected

            # Performs the actual validation logic.
            #
            # @abstract Subclasses must implement this method
            # @return [Boolean] True if validation passes
            # @raise [NotImplementedError] If not implemented by subclass
            def passes?
              raise NotImplementedError, "#{self.class} must implement #passes?"
            end

            # Builds a descriptive failure message when validation fails.
            #
            # @abstract Subclasses must implement this method
            # @return [String] Explanation of why validation failed
            # @raise [NotImplementedError] If not implemented by subclass
            def build_failure_message
              raise NotImplementedError, "#{self.class} must implement #build_failure_message"
            end

            private

            # @return [SubmatcherContext] The context with attribute data
            attr_reader :context
          end
        end
      end
    end
  end
end
