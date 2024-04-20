# frozen_string_literal: true

require "rails/generators/named_base"

module Servactory
  module Generators
    class RspecGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "input_name"

      def create_service
        create_file "app/services/#{file_path}_spec.rb" do
          <<~RUBY
            # frozen_string_literal: true

            RSpec.describe #{class_name}, type: :service do
              pending "add some examples to (or delete) #{__FILE__}"

              # let(:attributes) do
              #   {
              #{input_attribute_draw}
              #   }
              # end
              #
              #{input_let_draw}
              #
              # describe "validation" do
              #   describe "inputs" do
              #{input_validation_draw}
              #   end
              #
              #   describe "internals" do
              #     it { expect { perform }.to have_internal(:some_data).type(String) }
              #   end
              # end
              #
              # describe ".call!" do
              #   subject(:perform) { described_class.call!(**attributes) }
              #
              #   describe "and the data required for work is also valid" do
              #     it { expect(perform).to be_success_service }
              #
              #     # ...
              #   end
              #
              #   describe "but the data required for work is invalid" do
              #     # Provide a reason why the data is invalid and then use this:
              #     it { expect(perform).to be_failure_service }
              #
              #     # ...
              #   end
              # end
            end
          RUBY
        end
      end

      def input_attribute_draw
        input_names.map do |input_name|
          <<~RUBY.squish
            #     #{input_name}: #{input_name}
          RUBY
        end.join("\n  ")
      end

      def input_let_draw
        input_names.map do |input_name|
          <<~RUBY.squish
            # let(:#{input_name}) { "Some value" }
          RUBY
        end.join("\n  ")
      end

      def input_validation_draw
        input_names.map do |input_name|
          <<~RUBY.squish
            #     it { expect { perform }.to have_input(:#{input_name}).valid_with(attributes).type(String).required }
          RUBY
        end.join("\n  ")
      end

      def input_names
        @input_names ||= attributes_names
      end
    end
  end
end
