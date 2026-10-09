# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example22Collection
        include Enumerable

        def initialize(*items)
          @items = items.flatten
        end

        def each(&block)
          @items.each(&block)
        end
      end

      class Example22 < ApplicationService::Base
        configuration do
          collection_mode_class_names([Example22Collection])
        end

        input :items, type: Example22Collection, consists_of: String

        output :items, type: Example22Collection

        make :assign_output

        private

        def assign_output
          outputs.items = inputs.items
        end
      end
    end
  end
end
