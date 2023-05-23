# frozen_string_literal: true

module Servactory
  class Result
    def self.prepare_for(...)
      new.send(:prepare_for, ...)
    end

    private

    def prepare_for(context:, collection_of_output_attributes:)
      prepare_outputs_with(context: context, collection_of_output_attributes: collection_of_output_attributes)
      prepare_statuses_with(context: context)

      self
    end

    def prepare_outputs_with(context:, collection_of_output_attributes:)
      collection_of_output_attributes.each do |output|
        self.class.attr_reader(:"#{output.name}")

        instance_variable_set(:"@#{output.name}", context.instance_variable_get(:"@#{output.name}"))
      end
    end

    def prepare_statuses_with(context:)
      define_singleton_method(:errors) { context.errors }
      define_singleton_method(:success?) { context.errors.empty? }
      define_singleton_method(:failure?) { !context.errors.empty? }
    end
  end
end
