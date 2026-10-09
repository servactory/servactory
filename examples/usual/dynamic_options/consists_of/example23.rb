# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example23Collection
        include Enumerable

        def initialize(*items)
          @items = items.flatten
        end

        def each(&block)
          @items.each(&block)
        end
      end

      class Example23GrandParent < ApplicationService::Base
        configuration do
          collection_mode_class_names([Example23Collection])
        end
      end

      class Example23Parent < Example23GrandParent
      end

      class Example23 < Example23Parent
        input :items, type: Example23Collection, consists_of: String

        output :items, type: Example23Collection

        make :assign_output

        private

        def assign_output
          outputs.items = inputs.items
        end
      end
    end
  end
end
