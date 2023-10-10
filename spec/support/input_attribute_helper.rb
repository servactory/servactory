# frozen_string_literal: true

module InputAttributeHelper
  extend self

  # rubocop:disable Metrics/MethodLength
  def raise_input_error_for(
    check_name:,
    name:,
    service_class_name:,
    custom_message: nil,
    collection: false,
    collection_message: nil,
    expected_type: nil,
    given_type: nil
  ) # do
    raise_error(
      ApplicationService::Errors::InputError,
      prepare_input_text_for(
        check_name: check_name,
        name: name,
        service_class_name: service_class_name,
        custom_message: custom_message,
        collection: collection,
        collection_message: collection_message,
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
    collection: false,
    collection_message: nil,
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
        collection: collection,
        collection_message: collection_message,
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

  def prepare_input_type_check_text_for(
    name:,
    service_class_name:,
    collection:,
    collection_message:,
    expected_type:,
    given_type:
  ) # do
    expected_type = expected_type.join(", ") if expected_type.is_a?(Array)

    if collection
      if collection_message.present?
        collection_message
      else
        "[#{service_class_name}] Wrong type in input collection `#{name}`, expected `#{expected_type}`"
      end
    else
      "[#{service_class_name}] Wrong type of input `#{name}`, expected `#{expected_type}`, got `#{given_type}`"
    end
  end
end

RSpec.configure do |config|
  config.include InputAttributeHelper
end
