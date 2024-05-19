# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Optional
          class Example2 < ApplicationService::Base
            input :song_duration, type: String, required: false

            internal :song_duration, type: [String, NilClass], check_format: :duration

            output :song_duration, type: [ActiveSupport::Duration, NilClass]

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.song_duration = inputs.song_duration
            end

            def assign_output
              outputs.song_duration = if internals.song_duration.present?
                                        ActiveSupport::Duration.parse(internals.song_duration)
                                      else # rubocop:disable Style/EmptyElse
                                        nil
                                      end
            end
          end
        end
      end
    end
  end
end
