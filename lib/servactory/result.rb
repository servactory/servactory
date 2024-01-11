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

    def method_missing(name, *_args)
      super
    rescue NoMethodError => e
      rescue_no_method_error_with(exception: e)
    end

    def respond_to_missing?(*)
      super
    end

    private

    def as_success
      define_singleton_method(:success?) { true }
      define_singleton_method(:failure?) { false }

      @context.send(:servactory_service_storage).fetch(:outputs).each_pair do |key, value|
        define_singleton_method(:"#{key}?") { Servactory::Utils.query_attribute(value) }
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
      methods(false).sort.map do |method_name|
        "@#{method_name}=#{send(method_name)}"
      end.join(", ")
    end

    ########################################################################

    def rescue_no_method_error_with(exception:)
      raise @context.class.config.failure_class.new(
        message: I18n.t(
          "servactory.common.undefined_method.missing_name",
          service_class_name: @context.class.name,
          method_name: exception.name,
          missing_name: exception.missing_name.inspect
        )
      )
    end
  end
end
