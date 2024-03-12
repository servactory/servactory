# frozen_string_literal: true

module InputAttributeHelper
  extend self

  # rubocop:disable Metrics/MethodLength
  def raise_input_error_for(
    check_name:,
    name:,
    service_class_name:,
    custom_message: nil,
    expected_type: nil,
    given_type: nil
  ) # do
    raise_error(
      ApplicationService::Exceptions::Input,
      prepare_input_text_for(
        check_name: check_name,
        name: name,
        service_class_name: service_class_name,
        custom_message: custom_message,
        expected_type: expected_type,
        given_type: given_type
      )
    )
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def prepare_input_text_for(
    check_name:,
    name:,
    service_class_name:,
    custom_message: nil,
    expected_type: nil,
    given_type: nil
  ) # do
    case check_name.to_sym
    when :required
      prepare_input_required_check_text_for(
        name: name,
        service_class_name: service_class_name,
        custom_message: custom_message
      )
    when :type
      prepare_input_type_check_text_for(
        name: name,
        service_class_name: service_class_name,
        expected_type: expected_type,
        given_type: given_type
      )
    else
      raise "Non-existent `check_name` to generate the error text"
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def prepare_input_required_check_text_for(name:, service_class_name:, custom_message:)
    custom_message.presence || "[#{service_class_name}] Required input `#{name}` is missing"
  end

  # rubocop:disable Metrics/MethodLength
  def prepare_input_type_check_text_for(
    name:,
    service_class_name:,
    expected_type:,
    given_type:
  ) # do
    expected_type = expected_type.join(", ") if expected_type.is_a?(Array)

    "[#{service_class_name}] Wrong type of input `#{name}`, expected `#{expected_type}`, got `#{given_type}`"
  end
  # rubocop:enable Metrics/MethodLength
end

RSpec.configure do |config|
  config.include InputAttributeHelper
end
