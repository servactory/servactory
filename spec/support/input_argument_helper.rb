# frozen_string_literal: true

module InputArgumentHelper
  extend self

  def raise_input_argument_error_for(
    check_name:,
    name:,
    service_class_name:,
    array: false,
    expected_type: nil,
    given_type: nil
  ) # do
    raise_error(
      ApplicationService::Errors::InputArgumentError,
      prepare_input_argument_text_for(
        check_name: check_name,
        name: name,
        service_class_name: service_class_name,
        array: array,
        expected_type: expected_type,
        given_type: given_type
      )
    )
  end

  def prepare_input_argument_text_for(
    check_name:,
    name:,
    service_class_name:,
    array: false,
    expected_type: nil,
    given_type: nil
  ) # do
    case check_name.to_sym
    when :required
      prepare_input_argument_required_check_text_for(name: name, service_class_name: service_class_name)
    when :type
      prepare_input_argument_type_check_text_for(
        name: name,
        service_class_name: service_class_name,
        array: array,
        expected_type: expected_type,
        given_type: given_type
      )
    else
      raise "Non-existent `check_name` to generate the error text"
    end
  end

  private

  def prepare_input_argument_required_check_text_for(name:, service_class_name:)
    "[#{service_class_name}] Required input `#{name}` is missing"
  end

  def prepare_input_argument_type_check_text_for(name:, service_class_name:, array:, expected_type:, given_type:)
    expected_type = expected_type.join(", ") if expected_type.is_a?(Array)

    if array
      "[#{service_class_name}] Wrong type in input array `#{name}`, expected `#{expected_type}`"
    else
      "[#{service_class_name}] Wrong type of input `#{name}`, expected `#{expected_type}`, got `#{given_type}`"
    end
  end
end

RSpec.configure do |config|
  config.include InputArgumentHelper
end
