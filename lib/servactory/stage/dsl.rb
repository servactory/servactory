# frozen_string_literal: true

module Servactory
  module Stage
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        private

        attr_reader :stage_handyman

        def stage(&)
          @stage_factory ||= Factory.new

          @stage_factory.instance_eval(&)

          @stage_handyman = Handyman.work_in(@stage_factory)

          # @stage_factory

          nil
        end
      end
    end
  end
end
