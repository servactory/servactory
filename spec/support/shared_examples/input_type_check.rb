# frozen_string_literal: true

RSpec.shared_examples "input type check" do |name:, expected_type:, collection: false, collection_message: nil|
  describe "is of the wrong type" do
    let(name) do
      if collection == Array
        Array(Servactory::TestKit::FakeType.new)
      elsif collection == Set
        Set[Servactory::TestKit::FakeType.new]
      else
        Servactory::TestKit::FakeType.new
      end
    end

    it "returns expected error" do
      expect { perform }.to(
        raise_input_error_for(
          check_name: :type,
          name: name,
          service_class_name: described_class.name,
          collection: collection,
          collection_message: collection_message,
          expected_type: expected_type,
          given_type: Servactory::TestKit::FakeType
        )
      )
    end
  end
end
