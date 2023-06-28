# frozen_string_literal: true

module Servactory
  module Methods
    module Workspace
      def call!(arguments, collection_of_inputs)
        run_methods!
      end

      def run_methods!
        return try_to_use_call if self.class.send(:collection_of_stages).empty?

        self.class.send(:collection_of_stages).sorted_by_position.each do |stage|
          call_stage(stage)
        end
      end

      private

      def try_to_use_call
        try(:send, :call)
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
        wrapper.call(methods: -> { call_methods(methods) })
      rescue StandardError => e
        send(rollback, e) if rollback.present?
      end

      def call_methods(methods)
        methods.each do |make_method|
          next if unnecessary_for_make?(make_method)

          send(make_method.name)
        end
      end

      def unnecessary_for_stage?(stage)
        condition = stage.condition
        # is_condition_opposite = stage.is_condition_opposite

        result = prepare_condition_for(condition) # rubocop:disable Style/RedundantAssignment

        # is_condition_opposite ? !result : result
        result
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

        !condition.call(context: self)
      end
    end
  end
end
