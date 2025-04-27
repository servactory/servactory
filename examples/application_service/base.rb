# frozen_string_literal: true

require_relative "extensions/status_active/dsl"

module ApplicationService
  class Base
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL
    )

    FailOnLikeAnActiveRecordException = Class.new(ArgumentError)

    fail_on! FailOnLikeAnActiveRecordException

    # domain :application

    # configure { domain :application }
  end
end
