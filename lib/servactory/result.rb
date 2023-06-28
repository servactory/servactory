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

    # def method_missing(name, *args, &block)
    #   output = @collection_of_outputs&.find_by(name: name)
    #
    #   return super if output.nil?
    #
    #   output_value_for(output)
    # end
    #
    # def respond_to_missing?(name, *)
    #   @collection_of_outputs&.names&.include?(name) || super
    # end

    def inspect
      "#<#{self.class.name} #{draw_result}>"
    end

    private

    def as_success
      define_singleton_method(:success?) { true }
      define_singleton_method(:failure?) { false }

      # puts
      # puts
      # puts @context.send(:storage)[:outputs].inspect
      # puts
      # puts

      @context.send(:storage)[:outputs].each_pair do |key, value|
        define_singleton_method(key) { value }
      end

      self
    end

    def as_failure
      define_singleton_method(:error) { @exception }

      define_singleton_method(:success?) { false }
      define_singleton_method(:failure?) { true }

      self
    end

    def draw_result
      # @collection_of_outputs&.map do |output|
      #   puts
      #   puts
      #   puts :draw_result
      #   puts @context.send(:storage).inspect
      #   puts @context.send(:fetch_output, output.name).inspect
      #   puts
      #   puts
      #
      #   "@#{output.name}=#{output_value_for(output).inspect}"
      # end&.join(", ")

      @context.send(:storage)[:outputs].map do |key, value|
        "@#{key}=#{value}"
      end.join(", ")
    end

    # def output_value_for(output)
    #   # @context.instance_variable_get(:"@#{output.name}")
    #
    #   puts
    #   puts :output_value_for
    #   puts @context_store.context.__id__.inspect
    #   puts @context_store.data[:outputs].inspect
    #   puts @context_store.fetch_output(output.name).inspect
    #   puts
    #
    #   @context_store.fetch_output(output.name)
    # end
  end
end
