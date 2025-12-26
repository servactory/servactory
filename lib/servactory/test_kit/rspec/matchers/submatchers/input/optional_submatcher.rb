# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            class OptionalSubmatcher < Base::Submatcher
              def description
                "required: false"
              end

              protected

              def passes?
                input_required = attribute_data.fetch(:required).fetch(:is)
                input_required == false
              end

              def build_failure_message
                <<~MESSAGE
                  should be optional

                    expected required: false
                         got required: true
                MESSAGE
              end
            end
          end
        end
      end
    end
  end
end
