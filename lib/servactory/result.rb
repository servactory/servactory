# frozen_string_literal: true

module Servactory
  class Result
    def self.success_for(...)
      new(...).send(:as_success)
    end

    def self.failure_for(...)
      new(...).send(:as_failure)
    end

    def initialize(context: nil, collection_of_outputs: nil, exception: nil)
      @context = context
      @collection_of_outputs = collection_of_outputs
      @exception = exception
    end

    def method_missing(name, *args, &block)
      output = @collection_of_outputs&.find_by(name: name)

      return super if output.nil?

      @context.instance_variable_get(:"@#{output.name}")
    end

    def respond_to_missing?(name, *)
      @collection_of_outputs&.names&.include?(name) || super
    end

    def inspect
      "#<#{self.class.name} #{draw_result}>"
    end

    private

    def draw_result
      string = ""

      @collection_of_outputs&.each do |output|
        string += "@#{output.name}=#{@context.instance_variable_get(:"@#{output.name}").inspect}"
      end

      string
    end

    def as_success
      define_singleton_method(:success?) { true }
      define_singleton_method(:failure?) { false }

      self
    end

    def as_failure
      define_singleton_method(:error) { @exception }

      define_singleton_method(:success?) { false }
      define_singleton_method(:failure?) { true }

      self
    end
  end
end
