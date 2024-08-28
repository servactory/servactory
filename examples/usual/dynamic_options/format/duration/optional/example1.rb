# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Optional
          class Example1 < ApplicationService::Base
            input :song_duration, type: String, format: :duration, required: false

            output :song_duration, type: [ActiveSupport::Duration, NilClass]

            make :assign_output

            private

            def assign_output
              outputs.song_duration = if inputs.song_duration.present?
                                        ActiveSupport::Duration.parse(inputs.song_duration)
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
