# frozen_string_literal: true

module Usual
  module Extensions
    class Example1 < ApplicationService::Base
      class User
        def initialize(active: false)
          @active = active
        end

        def active?
          active
        end

        private

        attr_accessor :active
      end

      input :user, type: User

      status_active! :user

      def call
        # nothing
      end
    end
  end
end
