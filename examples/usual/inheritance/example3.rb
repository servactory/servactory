# frozen_string_literal: true

module Usual
  module Inheritance
    class Example3Base < ApplicationService::Base
      input :locale, type: String, required: false, default: "en"

      internal :code, type: String

      output :code, type: String

      make :assign_internal_code

      make :assign_output_code

      private

      def assign_internal_code
        internals.code = inputs.locale.upcase
      end

      def assign_output_code
        outputs.code = internals.code
      end
    end

    class Example3 < Example3Base
      input :locale, type: String, required: false, default: "de"

      internal :code, type: Symbol

      output :code, type: Symbol

      private

      def assign_internal_code
        internals.code = inputs.locale.upcase.to_sym
      end
    end
  end
end
