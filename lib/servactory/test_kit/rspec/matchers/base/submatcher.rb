# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          class Submatcher
            include RSpec::Matchers::Composable
            include Concerns::AttributeDataAccess
            include Concerns::ErrorMessageBuilder
            include Concerns::ValueComparison

            attr_reader :missing_option

            def initialize(context)
              @context = context
              @missing_option = ""
            end

            def matches?(_subject)
              if passes?
                true
              else
                @missing_option = build_failure_message
                false
              end
            end

            def failure_message
              @missing_option
            end

            def failure_message_when_negated
              "expected not to #{description}"
            end

            def description
              raise NotImplementedError, "#{self.class} must implement #description"
            end

            protected

            def passes?
              raise NotImplementedError, "#{self.class} must implement #passes?"
            end

            def build_failure_message
              raise NotImplementedError, "#{self.class} must implement #build_failure_message"
            end

            private

            attr_reader :context
          end
        end
      end
    end
  end
end
