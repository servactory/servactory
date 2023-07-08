# frozen_string_literal: true

module Servactory
  module Inputs
    module OptionHelpers
      module Types # rubocop:disable Metrics/ModuleLength
        module_function

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
          Servactory::Inputs::OptionHelper.new(
            name: :symbol,
            equivalent: {
              type: Symbol
            }
          )
        end

        def symbol?
          Servactory::Inputs::OptionHelper.new(
            name: :symbol?,
            equivalent: {
              type: Symbol,
              required: false,
              default: nil
            }
          )
        end

        def string
          Servactory::Inputs::OptionHelper.new(
            name: :string,
            equivalent: {
              type: String
            }
          )
        end

        def string?
          Servactory::Inputs::OptionHelper.new(
            name: :string?,
            equivalent: {
              type: String,
              required: false,
              default: nil
            }
          )
        end

        def integer
          Servactory::Inputs::OptionHelper.new(
            name: :integer,
            equivalent: {
              type: Integer
            }
          )
        end

        def integer?
          Servactory::Inputs::OptionHelper.new(
            name: :integer?,
            equivalent: {
              type: Integer,
              required: false,
              default: nil
            }
          )
        end

        def float
          Servactory::Inputs::OptionHelper.new(
            name: :float,
            equivalent: {
              type: Float
            }
          )
        end

        def float?
          Servactory::Inputs::OptionHelper.new(
            name: :float?,
            equivalent: {
              type: Float,
              required: false,
              default: nil
            }
          )
        end

        def boolean
          Servactory::Inputs::OptionHelper.new(
            name: :boolean,
            equivalent: {
              type: [TrueClass, FalseClass]
            }
          )
        end

        def array
          Servactory::Inputs::OptionHelper.new(
            name: :array,
            equivalent: {
              type: Array
            }
          )
        end

        def array?
          Servactory::Inputs::OptionHelper.new(
            name: :array?,
            equivalent: {
              type: Array,
              required: false,
              default: nil
            }
          )
        end

        def hash
          Servactory::Inputs::OptionHelper.new(
            name: :hash,
            equivalent: {
              type: Hash
            }
          )
        end

        def hash?
          Servactory::Inputs::OptionHelper.new(
            name: :hash?,
            equivalent: {
              type: Hash,
              required: false,
              default: nil
            }
          )
        end
      end
    end
  end
end
