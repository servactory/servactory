# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example1, type: :service do
  let(:attributes) do
    {
      payload:
    }
  end

  let(:payload) do
    {
      request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
      user: {
        first_name:,
        middle_name:,
        last_name:
      }
    }
  end

  let(:first_name) { "John" }
  let(:middle_name) { nil }
  let(:last_name) { "Kennedy" }

  include_examples "check class info",
                   inputs: %i[payload],
                   internals: %i[],
                   outputs: %i[]

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "but the data required for work is invalid" do
      context "when the value type for `first_name` is wrong" do
        let(:first_name) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Schema::Example1] Wrong type in input hash `payload`, " \
              "expected `String` for `first_name`, got `Integer`"
            )
          )
        end
      end

      context "when the value type for `middle_name` is wrong" do
        let(:middle_name) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Schema::Example1] Wrong type in input hash `payload`, " \
              "expected `String` for `middle_name`, got `Integer`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "but the data required for work is invalid" do
      context "when the value type for `first_name` is wrong" do
        let(:first_name) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Schema::Example1] Wrong type in input hash `payload`, " \
              "expected `String` for `first_name`, got `Integer`"
            )
          )
        end
      end

      context "when the value type for `middle_name` is wrong" do
        let(:middle_name) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Schema::Example1] Wrong type in input hash `payload`, " \
              "expected `String` for `middle_name`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
