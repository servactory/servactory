# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Basic
          class Example2 < ApplicationService::Base
            input :song_duration, type: String

            internal :song_duration, type: String, check_format: :duration

            output :song_duration, type: ActiveSupport::Duration

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.song_duration = inputs.song_duration
            end

            def assign_output
              outputs.song_duration = ActiveSupport::Duration.parse(internals.song_duration)
            end
          end
        end
      end
    end
  end
end
