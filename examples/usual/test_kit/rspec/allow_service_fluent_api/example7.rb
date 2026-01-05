# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) without inputs
        class Example7Child < ApplicationService::Base
          output :timestamp, type: Time
          output :status, type: Symbol

          make :process

          private

          def process
            outputs.timestamp = Time.now
            outputs.status = :healthy
          end
        end

        # Parent service (tested, calls child without inputs)
        class Example7 < ApplicationService::Base
          output :health_check_time, type: Time
          output :system_status, type: Symbol

          make :check_health

          private

          def check_health
            result = Example7Child.call

            raise result.error if result.failure?

            outputs.health_check_time = result.timestamp
            outputs.system_status = result.status
          end
        end
      end
    end
  end
end
