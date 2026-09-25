# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Adapts blocks given to `and_wrap_original` to the arguments of service calls.
        #
        # ## Purpose
        #
        # Services accept inputs as keywords, as a positional Hash or as
        # a Datory object. A block accepting keywords receives the inputs as
        # keywords in each case, converted with Servactory::Utils.adapt the way
        # the service converts them, so String keys and HashWithIndifferentAccess
        # arrive as Symbol keys. Any other block receives the arguments as given,
        # the way RSpec's `and_wrap_original` passes them, so a call with an
        # empty positional Hash passes `{}` to it.
        #
        # The adaptation is chosen once from the block parameters.
        #
        # ## Usage
        #
        # Used internally by MockExecutor:
        #
        # ```ruby
        # delegate = WrapBlockAdapter.adapt(wrap_block)
        #
        # delegate.call(original, *arguments, &block)
        # ```
        class WrapBlockAdapter
          KEYWORD_PARAMETER_TYPES = %i[key keyreq keyrest].freeze

          private_constant :KEYWORD_PARAMETER_TYPES

          class << self
            # Adapts a wrap block to the arguments of service calls.
            #
            # @param wrap_block [Proc] Block given to and_wrap_original
            # @return [Proc] Callable receiving the original method and the call arguments
            def adapt(wrap_block)
              return wrap_block unless accepts_keywords?(wrap_block)

              with_keyword_inputs(wrap_block)
            end

            private

            # Checks whether a block declares keyword parameters.
            #
            # @param wrap_block [Proc] Block given to and_wrap_original
            # @return [Boolean] True if the block accepts keywords
            def accepts_keywords?(wrap_block)
              wrap_block.parameters.any? { |type, _name| KEYWORD_PARAMETER_TYPES.include?(type) }
            end

            # Adapts a block to receive service inputs as keywords.
            #
            # @param wrap_block [Proc] Block accepting keywords
            # @return [Proc] Callable passing the inputs of a call to the block as Symbol keywords
            def with_keyword_inputs(wrap_block)
              lambda do |original, *arguments, &block|
                if arguments.one? && Servactory::Utils.adaptable?(arguments.first)
                  wrap_block.call(original, **Servactory::Utils.adapt(arguments.first), &block)
                else
                  wrap_block.call(original, *arguments, &block)
                end
              end
            end
          end
        end
      end
    end
  end
end
