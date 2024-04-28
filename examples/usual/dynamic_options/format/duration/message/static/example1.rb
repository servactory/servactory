# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Message
          module Static
            class Example1 < ApplicationService::Base
              input :song_duration,
                    type: String,
                    format: {
                      is: :duration,
                      message: "Invalid duration format"
                    }

              output :song_duration, type: ActiveSupport::Duration

              make :assign_output

              private

              def assign_output
                outputs.song_duration = ActiveSupport::Duration.parse(inputs.song_duration)
              end
            end
          end
        end
      end
    end
  end
end
