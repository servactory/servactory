# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example21Collection
        include Enumerable

        def initialize(*items)
          @items = items.flatten
        end

        def each(&block)
          @items.each(&block)
        end
      end

      class Example21Parent < ApplicationService::Base
        configuration do
          collection_mode_class_names([Example21Collection])
        end
      end

      class Example21 < Example21Parent
        input :items, type: Example21Collection, consists_of: String

        output :items, type: Example21Collection

        make :assign_output

        private

        def assign_output
          outputs.items = inputs.items
        end
      end
    end
  end
end
