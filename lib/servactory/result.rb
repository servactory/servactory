# frozen_string_literal: true

module Servactory
  class Result
    def self.success_for(...)
      new(...).send(:as_success)
    end

    def self.failure_for(...)
      new(...).send(:as_failure)
    end

    def initialize(context: nil, exception: nil)
      @context = context
      @exception = exception
    end

    def inspect
      "#<#{self.class.name} #{draw_result}>"
    end

    private

    def as_success
      define_singleton_method(:success?) { true }
      define_singleton_method(:failure?) { false }

      @context.send(:service_storage).fetch(:outputs).each_pair do |key, value|
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
      @context.send(:service_storage).fetch(:outputs).map do |key, value|
        "@#{key}=#{value}"
      end.join(", ")
    end
  end
end
