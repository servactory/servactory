# frozen_string_literal: true

module Servactory
  class Result
    class Outputs
      def initialize(outputs:, predicate_methods_enabled:)
        outputs.each_pair do |key, value|
          define_singleton_method(:"#{key}?") { Servactory::Utils.query_attribute(value) } if predicate_methods_enabled
          define_singleton_method(key) { value }
        end
      end

      def inspect
        "#<#{self.class.name} #{draw_result}>"
      end

      private

      def draw_result
        methods(false).sort.map do |method_name|
          "@#{method_name}=#{send(method_name)}"
        end.join(", ")
      end
    end

    private_constant :Outputs

    ############################################################################

    STATE_PREDICATE_NAMES = %i[success? failure?].freeze
    private_constant :STATE_PREDICATE_NAMES

    def self.success_for(context:)
      new(context:).send(:as_success)
    end

    def self.failure_for(context:, exception:)
      new(context:, exception:).send(:as_failure)
    end

    def initialize(context:, exception: nil)
      @context = context
      @exception = exception
    end

    def to_h
      methods(false)
        .reject { |key| key.in?(STATE_PREDICATE_NAMES) || key.to_s.end_with?("?") }
        .to_h { |key| [key, public_send(key)] }
        .compact
    end

    def inspect
      "#<#{self.class.name} #{draw_result}>"
    end

    def on_success
      yield(outputs:) if success?

      self
    end

    def on_failure(type = :all)
      yield(outputs:, exception: @exception) if failure? && [:all, @exception&.type].include?(type)

      self
    end

    def method_missing(name, *args, &block)
      super
    rescue NoMethodError => e
      rescue_no_method_error_with(exception: e)
    end

    def respond_to_missing?(*_args)
      super
    end

    private

    def as_success
      define_singleton_method(:success?) { true }
      define_singleton_method(:failure?) { false }

      outputs.methods(false).each do |method_name|
        define_singleton_method(method_name) { outputs.send(method_name) }
      end

      self
    end

    def as_failure
      define_singleton_method(:error) { @exception }

      define_singleton_method(:success?) { false }

      define_singleton_method(:failure?) do |type = :all|
        return true if [:all, @exception&.type].include?(type)

        false
      end

      outputs.methods(false).each do |method_name|
        define_singleton_method(method_name) { outputs.send(method_name) }
      end

      self
    end

    def draw_result
      methods(false).sort.map do |method_name|
        "@#{method_name}=#{send(method_name)}"
      end.join(", ")
    end

    def outputs
      @outputs ||= Outputs.new(
        outputs: @context.send(:servactory_service_warehouse).outputs,
        predicate_methods_enabled:
          @context.is_a?(Servactory::TestKit::Result) || @context.class.config.predicate_methods_enabled?
      )
    end

    ########################################################################

    def rescue_no_method_error_with(exception:) # rubocop:disable Metrics/MethodLength
      raise exception if @context.blank? || @context.instance_of?(Servactory::TestKit::Result)

      raise @context.class.config.failure_class.new(
        type: :base,
        message: @context.send(:servactory_service_info).translate(
          "common.undefined_method.missing_name",
          error_text: exception.message
        ),
        meta: {
          original_exception: exception
        }
      )
    end
  end
end
