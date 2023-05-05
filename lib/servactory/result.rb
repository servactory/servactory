# frozen_string_literal: true

module Servactory
  class Result
    def self.prepare_for(...)
      new.send(:prepare_for, ...)
    end

    private

    def prepare_for(context:, collection_of_output_arguments:)
      collection_of_output_arguments.each do |output|
        self.class.attr_reader(:"#{output.name}")

        instance_variable_set(:"@#{output.name}", context.instance_variable_get(:"@#{output.name}"))
      end

      self
    end
  end
end
