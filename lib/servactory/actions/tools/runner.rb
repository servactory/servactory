# frozen_string_literal: true

module Servactory
  module Actions
    module Tools
      class Runner
        def self.run!(...)
          new(...).run!
        end

        def initialize(context, collection_of_stages)
          @context = context
          @collection_of_stages = collection_of_stages
        end

        def run!
          return use_call if @collection_of_stages.empty?

          @collection_of_stages.sorted_by_position.each do |stage|
            call_stage(stage)
          end
        end

        private

        def use_call
          @context.send(:call)
        end

        def call_stage(stage)
          return if unnecessary_for_stage?(stage)

          wrapper = stage.wrapper
          rollback = stage.rollback
          methods = stage.methods.sorted_by_position

          if wrapper.is_a?(Proc)
            call_wrapper_with_methods(wrapper, rollback, methods)
          else
            call_methods(methods)
          end
        end

        def call_wrapper_with_methods(wrapper, rollback, methods)
          wrapper.call(methods: -> { call_methods(methods) }, context: @context)
        rescue StandardError => e
          @context.send(rollback, e) if rollback.present?
        end

        def call_methods(methods)
          methods.each do |method|
            next if unnecessary_for_make?(method)

            call_method(method)
          end
        end

        def call_method(method)
          @context.send(method.name)
        rescue NoMethodError => e
          rescue_no_method_error_with(exception: e)
        rescue NameError
          rescue_name_error_with(method: method)
        end

        def unnecessary_for_stage?(stage)
          condition = stage.condition
          is_condition_opposite = stage.is_condition_opposite

          result = prepare_condition_for(condition)

          is_condition_opposite ? !result : result
        end

        def unnecessary_for_make?(make_method)
          condition = make_method.condition
          is_condition_opposite = make_method.is_condition_opposite

          result = prepare_condition_for(condition)

          is_condition_opposite ? !result : result
        end

        def prepare_condition_for(condition)
          return false if condition.nil?
          return !Servactory::Utils.true?(condition) unless condition.is_a?(Proc)

          !condition.call(context: @context)
        end

        ########################################################################

        def rescue_no_method_error_with(exception:) # rubocop:disable Metrics/MethodLength
          raise @context.class.config.failure_class.new(
            message: I18n.t(
              "servactory.common.undefined_method.missing_name",
              service_class_name: @context.class.name,
              method_name: exception.name,
              missing_name: if exception.missing_name.nil?
                              exception.missing_name.inspect
                            elsif exception.missing_name == "NilClass"
                              nil.inspect
                            else
                              exception.missing_name
                            end
            )
          )
        end

        def rescue_name_error_with(method:)
          raise @context.class.config.failure_class.new(
            message: I18n.t(
              "servactory.common.undefined_local_variable_or_method",
              service_class_name: @context.class.name,
              method_name: method.name
            )
          )
        end
      end
    end
  end
end
