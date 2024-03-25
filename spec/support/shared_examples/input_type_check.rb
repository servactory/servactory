# frozen_string_literal: true

RSpec.shared_examples "input type check" do |name:, expected_type:|
  describe "is of the wrong type" do
    let(name) { Servactory::TestKit::FakeType.new }

    it "returns expected error" do
      expect { perform }.to(
        raise_input_error_for(
          check_name: :type,
          name: name,
          service_class_name: described_class.name,
          expected_type: expected_type,
          given_type: Servactory::TestKit::FakeType
        )
      )
    end
  end
end
