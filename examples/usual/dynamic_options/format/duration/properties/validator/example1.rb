# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Properties
          module Validator
            class Example1 < ApplicationService::Base
              input :song_duration,
                    type: String,
                    format: {
                      is: :duration,
                      pattern: nil, # This will disable the value checking based on the pattern
                      validator: lambda do |value:|
                        value.start_with?("P") && value.end_with?("D")
                      end
                    }

              output :song_duration, type: String

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
