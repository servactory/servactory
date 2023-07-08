# frozen_string_literal: true

module Servactory
  module Inputs
    module OptionHelpers
      module Types
        module_function

        def mandatory(name, type)
          Servactory::Inputs::OptionHelper.new(
            name: name.to_sym,
            equivalent: {
              type: type
            }
          )
        end

        def not_mandatory(name, type)
          Servactory::Inputs::OptionHelper.new(
            name: "#{name}?".to_sym,
            equivalent: {
              type: type,
              required: false,
              default: nil
            }
          )
        end

        def all
          Set[
            symbol, symbol?,
            string, string?,
            integer, integer?,
            float, float?,
            boolean,
            array, array?,
            hash, hash?
          ]
        end

        def symbol
          mandatory(:symbol, Symbol)
        end

        def symbol?
          not_mandatory(:symbol, Symbol)
        end

        def string
          mandatory(:string, String)
        end

        def string?
          not_mandatory(:string, String)
        end

        def integer
          mandatory(:integer, Integer)
        end

        def integer?
          not_mandatory(:integer, Integer)
        end

        def float
          mandatory(:float, Float)
        end

        def float?
          not_mandatory(:float, Float)
        end

        def boolean
          mandatory(:boolean, [TrueClass, FalseClass])
        end

        def array
          mandatory(:array, Array)
        end

        def array?
          not_mandatory(:array, Array)
        end

        def hash
          mandatory(:hash, Hash)
        end

        def hash?
          not_mandatory(:hash, Hash)
        end
      end
    end
  end
end
