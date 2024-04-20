# frozen_string_literal: true

require "rails/generators/named_base"

module Servactory
  module Generators
    class ServiceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "input_name"

      def create_service
        create_file "app/services/#{file_path}.rb" do
          <<~RUBY
            # frozen_string_literal: true

            class #{class_name} < ApplicationService::Base
              #{input_draw}

              output :result, type: Symbol

              make :something

              private

              def something
                # Write your code here

                outputs.result = :done
              end
            end
          RUBY
        end
      end

      def input_draw
        input_names.map do |input_name|
          <<~RUBY.squish
            input :#{input_name}, type: String
          RUBY
        end.join("\n  ")
      end

      def input_names
        @input_names ||= attributes_names
      end
    end
  end
end
