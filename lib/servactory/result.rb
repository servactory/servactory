# frozen_string_literal: true

module Servactory
  class Result
    class Outputs
      def initialize(outputs:, predicates_enabled:)
        outputs.each_pair do |key, value|
          define_singleton_method(:"#{key}?") { Servactory::Utils.query_attribute(value) } if predicates_enabled
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

    def self.success_for(context:)
      new(context: context).send(:as_success)
    end

    def self.failure_for(context:, exception:)
      new(context: context, exception: exception).send(:as_failure)
    end

    def initialize(context:, exception: nil)
      @context = context
      @exception = exception
    end

    def inspect
      "#<#{self.class.name} #{draw_result}>"
    end

    def on_success
      yield(outputs: outputs) if success?

      self
    end

    def on_failure(type = :all)
      yield(outputs: outputs, exception: @exception) if failure? && [:all, @exception&.type].include?(type)

      self
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
        outputs: @context.send(:servactory_service_store).outputs,
        predicates_enabled: if @context.is_a?(Servactory::TestKit::Result)
                              true
                            else
                              @context.class.config.predicates_enabled?
                            end
      )
    end

    ########################################################################

    def rescue_no_method_error_with(exception:) # rubocop:disable Metrics/MethodLength
      raise exception if @context.blank? || @context.instance_of?(Servactory::TestKit::Result)

      raise @context.class.config.failure_class.new(
        type: :base,
        message: I18n.t(
          "servactory.common.undefined_method.missing_name",
          service_class_name: @context.class.name,
          error_text: exception.message
        ),
        meta: {
          original_exception: exception
        }
      )
    end
  end
end
