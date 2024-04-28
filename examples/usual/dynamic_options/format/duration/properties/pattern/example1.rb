# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Properties
          module Pattern
            class Example1 < ApplicationService::Base
              input :song_duration,
                    type: String,
                    format: {
                      is: :duration,
                      pattern: /^P(?=\d+[YMWD])(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(?=\d+[HMS])(\d+H)?(\d+M)?(\d+S)?)?$/
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
