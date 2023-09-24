# frozen_string_literal: true

module Usual
  class Example64 < ApplicationService::Base
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

    status_active! record: ->(inputs:) { inputs.user }

    # make :perform

    def call
      puts
      puts :real_call
      puts

      # inputs.user.name = "NAME"
    end

    # def perform
    #   puts
    #   puts :real_perform
    #   puts
    # end
  end
end
