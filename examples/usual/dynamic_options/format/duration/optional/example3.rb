# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Duration
        module Optional
          class Example3 < ApplicationService::Base
            input :song_duration, type: String, required: false

            output :song_duration, type: [String, NilClass], format: :duration

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
