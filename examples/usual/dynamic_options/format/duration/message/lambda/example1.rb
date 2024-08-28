# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Message
          module Lambda
            class Example1 < ApplicationService::Base
              input :song_duration,
                    type: String,
                    format: {
                      is: :duration,
                      message: lambda do |input:, value:, option_value:, **|
                        "Value `#{value}` does not match the format of `#{option_value}` in `#{input.name}`"
                      end
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
