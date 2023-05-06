# frozen_string_literal: true

RSpec.shared_examples "input type check" do |name:, expected_type:, array: false, array_message: nil|
  describe "is of the wrong type" do
    let(name) { array ? Array(FakeServiceType.new) : FakeServiceType.new }

    before { stub_const("FakeServiceType", Class.new) }

    it "returns expected error" do
      expect { perform }.to(
        raise_input_argument_error_for(
          check_name: :type,
          name: name,
          service_class_name: described_class.name,
          array: array,
          array_message: array_message,
          expected_type: expected_type,
          given_type: FakeServiceType
        )
      )
    end
  end
end
