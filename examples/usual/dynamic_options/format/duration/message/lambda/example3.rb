# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Message
          module Lambda
            class Example3 < ApplicationService::Base
              input :song_duration, type: String

              output :song_duration,
                     type: String,
                     format: {
                       is: :duration,
                       message: lambda do |output:, value:, option_value:, **|
                         "Value `#{value}` does not match the format of `#{option_value}` in `#{output.name}`"
                       end
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
