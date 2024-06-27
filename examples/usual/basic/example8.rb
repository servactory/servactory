# frozen_string_literal: true

module Usual
  module Basic
    class Example8 < ApplicationService::Base
      # NOTE: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
      User = Struct.new(:email, :password, keyword_init: true) do
        def self.find_by(email:)
          return if email != "correct@email.com"

          new(email:)
        end

        def authenticate(password)
          return unless password == "correct_password"

          self.password = password

          self
        end
      end

      input :email, type: String
      input :password, type: String

      output :user, type: User

      private

      def call
        if (user = User.find_by(email: inputs.email)&.authenticate(inputs.password))
          outputs.user = user
        else
          fail!(message: "Authentication failed")
        end
      end
    end
  end
end
