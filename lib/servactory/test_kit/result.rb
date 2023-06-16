# frozen_string_literal: true

module Servactory
  module TestKit
    class Result
      def initialize(**attributes)
        attributes.each_pair do |method_name, method_return|
          define_singleton_method(method_name) { method_return }
        end
      end
    end
  end
end
