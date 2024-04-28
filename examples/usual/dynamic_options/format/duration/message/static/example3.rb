# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Message
          module Static
            class Example3 < ApplicationService::Base
              input :song_duration, type: String

              output :song_duration,
                     type: String,
                     format: {
                       is: :duration,
                       message: "Invalid duration format"
                     }

              make :assign_output

              private

              def assign_output
                outputs.song_duration = inputs.song_duration
              end
            end
          end
        end
      end
    end
  end
end
