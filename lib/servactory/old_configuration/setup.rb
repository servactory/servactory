# frozen_string_literal: true

module Servactory
  module OldConfiguration
    class Setup
      attr_accessor :domain

      def initialize
        @domain = :application
      end
    end
  end
end
