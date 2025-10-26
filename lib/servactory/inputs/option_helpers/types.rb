# frozen_string_literal: true

module Servactory
  module Inputs
    module OptionHelpers
      module Types
        module_function

        def mandatory(name, type)
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: name.to_sym,
            equivalent: {
              type: type
            }
          )
        end

        def not_mandatory(name, type)
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :"#{name}?",
            equivalent: {
              type: type,
              required: false,
              default: nil
            }
          )
        end

        def all # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          Set[
            symbol, symbol?,
            string, string?,
            numeric, numeric?,
            integer, integer?,
            float, float?,
            boolean,
            array, array?,
            set, set?,
            hash, hash?,
            date, date?,
            time, time?
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

        def numeric
          mandatory(:numeric, Numeric)
        end

        def numeric?
          not_mandatory(:numeric, Numeric)
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

        def set
          mandatory(:array, Set)
        end

        def set?
          not_mandatory(:array, Set)
        end

        def hash
          mandatory(:hash, Hash)
        end

        def hash?
          not_mandatory(:hash, Hash)
        end

        def date
          mandatory(:date, Date)
        end

        def date?
          not_mandatory(:date, Date)
        end

        def time
          mandatory(:time, Time)
        end

        def time?
          not_mandatory(:time, Time)
        end
      end
    end
  end
end
