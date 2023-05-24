# frozen_string_literal: true

RSpec.shared_examples "input required check" do |name:, custom_message: nil|
  describe "is not passed" do
    let(name) { nil }

    it "returns expected error" do
      expect { perform }.to(
        raise_input_error_for(
          check_name: :required,
          name: name,
          service_class_name: described_class.name,
          custom_message: custom_message
        )
      )
    end
  end
end
