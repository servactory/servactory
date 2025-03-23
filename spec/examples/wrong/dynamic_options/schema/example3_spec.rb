# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example3, type: :service do
  include_examples "check class info",
                   inputs: %i[],
                   internals: %i[payload],
                   outputs: %i[]

  describe ".call!" do
    subject(:perform) { described_class.call! }

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::Schema::Example3] Wrong type in internal attribute hash `payload`, " \
            "expected `String` for `last_name`, got `NilClass`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::Schema::Example3] Wrong type in internal attribute hash `payload`, " \
            "expected `String` for `last_name`, got `NilClass`"
          )
        )
      end
    end
  end
end
