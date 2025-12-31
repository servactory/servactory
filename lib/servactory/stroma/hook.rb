# frozen_string_literal: true

module Servactory
  module Stroma
    Hook = Data.define(:type, :target_key, :extension) do
      def before?
        type == :before
      end

      def after?
        type == :after
      end
    end
  end
end
