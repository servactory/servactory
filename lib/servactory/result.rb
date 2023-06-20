# frozen_string_literal: true

module Servactory
  class Result
    def self.success_for(...)
      new.send(:success_for, ...)
    end

    def self.failure_for(...)
      new.send(:failure_for, ...)
    end

    private

    def success_for(context:, collection_of_outputs:)
      prepare_outputs_with(context: context, collection_of_outputs: collection_of_outputs)

      define_singleton_method(:success?) { true }
      define_singleton_method(:failure?) { false }

      self
    end

    def failure_for(exception:)
      define_singleton_method(:error) { exception }

      define_singleton_method(:success?) { false }
      define_singleton_method(:failure?) { true }

      self
    end

    def prepare_outputs_with(context:, collection_of_outputs:)
      collection_of_outputs.each do |output|
        self.class.attr_reader(:"#{output.name}")

        instance_variable_set(:"@#{output.name}", context.instance_variable_get(:"@#{output.name}"))
      end
    end
  end
end
