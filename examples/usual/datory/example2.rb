# frozen_string_literal: true

require "datory"

module Usual
  module Datory
    class Example2 < ApplicationService::Base
      class Event < ::Datory::Base
        uuid! :id
      end

      input :id, type: String

      output :id, type: String

      make :assign_id

      private

      def assign_id
        outputs.id = inputs.id
      end
    end
  end
end
