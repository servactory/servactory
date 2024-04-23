# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Result do
  describe ".new" do
    it "returns expected error" do
      expect { described_class.new }.to(
        raise_error(
          NoMethodError,
          if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
            "private method `new' called for class Servactory::TestKit::Result"
          else
            "private method `new' called for Servactory::TestKit::Result:Class"
          end
        )
      )
    end
  end

  describe ".as_success" do
    it :aggregate_failures do # rubocop:disable RSpec/RepeatedDescription
      result = described_class.as_success

      expect(result).to be_a(Servactory::Result)
      expect(result).to an_instance_of(Servactory::Result)
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it :aggregate_failures do # rubocop:disable RSpec/RepeatedDescription
      result = described_class.as_success(test_attribute: :test_value)

      expect(result).to be_a(Servactory::Result)
      expect(result).to an_instance_of(Servactory::Result)
      expect(result).to be_success
      expect(result).not_to be_failure
      expect(result.test_attribute).to eq(:test_value)
    end
  end

  describe ".as_failure" do
    it :aggregate_failures do # rubocop:disable RSpec/RepeatedDescription
      result = described_class.as_failure

      expect(result).to be_a(Servactory::Result)
      expect(result).to an_instance_of(Servactory::Result)
      expect(result).not_to be_success
      expect(result).to be_failure
    end

    it :aggregate_failures do # rubocop:disable RSpec/RepeatedDescription
      result = described_class.as_failure(
        exception: Servactory::Exceptions::Failure.new(
          type: :base,
          message: "Test error message"
        )
      )

      expect(result).to be_a(Servactory::Result)
      expect(result).to an_instance_of(Servactory::Result)
      expect(result).not_to be_success
      expect(result).to be_failure
      expect(result.error).to be_a(Servactory::Exceptions::Failure)
      expect(result.error.message).to eq("Test error message")
    end
  end
end
