# frozen_string_literal: true

RSpec.shared_examples "input required check" do |name:|
  describe "is not passed" do
    let(name) { nil }

    it "returns expected error" do
      expect { perform }.to(
        raise_input_argument_error_for(
          check_name: :required,
          name:,
          service_class_name: described_class.name
        )
      )
    end
  end
end
