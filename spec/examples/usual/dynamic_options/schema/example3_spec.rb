# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example3, type: :service do
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
        last_name:,
        passport: {
          series:,
          number:
        }
      }
    }
  end

  let(:first_name) { "John" }
  let(:middle_name) { nil }
  let(:last_name) { "Kennedy" }
  let(:series) { "HR" }
  let(:number) { "88467617508" }

  include_examples "check class info",
                   inputs: %i[payload],
                   internals: %i[payload],
                   outputs: %i[full_name]

  describe "validation" do
    describe "inputs" do
      it do # rubocop:disable RSpec/ExampleLength
        expect { perform }.to(
          have_input(:payload)
            .valid_with(attributes)
            .type(Hash)
            .schema(
              {
                request_id: { type: String, required: true },
                user: {
                  type: Hash,
                  required: true,
                  first_name: { type: String, required: true },
                  middle_name: { type: String, required: false, default: "<unknown>" },
                  last_name: { type: String, required: true },
                  passport: {
                    type: Hash,
                    required: true,
                    series: { type: String, required: true },
                    number: { type: String, required: true }
                  },
                  session: {
                    type: Hash,
                    required: false,
                    default: {}
                  }
                }
              }
            )
            .required
        )
      end
    end

    describe "internals" do
      it do # rubocop:disable RSpec/ExampleLength
        expect { perform }.to(
          have_internal(:payload)
            .type(Hash)
            .schema(
              {
                request_id: { type: String, required: true },
                user: {
                  type: Hash,
                  required: true,
                  first_name: { type: String, required: true },
                  middle_name: { type: String, required: false, default: "<unknown>" },
                  last_name: { type: String, required: true },
                  passport: {
                    type: Hash,
                    required: true,
                    series: { type: String, required: true },
                    number: { type: String, required: true }
                  },
                  session: {
                    type: Hash,
                    required: false,
                    default: {}
                  }
                }
              }
            )
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      describe "without middle name" do
        it { expect(perform).to have_output(:full_name).contains("John <unknown> Kennedy") }
      end

      describe "with middle name" do
        let(:middle_name) { "Fitzgerald" }

        it { expect(perform).to have_output(:full_name).contains("John Fitzgerald Kennedy") }
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one of the values is of the wrong type" do
        let(:number) { 88_467_617_508 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example3] Wrong type in input hash `payload`, " \
              "expected `String` for `number`, got `Integer`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      describe "without middle name" do
        it { expect(perform).to have_output(:full_name).contains("John <unknown> Kennedy") }
      end

      describe "with middle name" do
        let(:middle_name) { "Fitzgerald" }

        it { expect(perform).to have_output(:full_name).contains("John Fitzgerald Kennedy") }
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one of the values is of the wrong type" do
        let(:number) { 88_467_617_508 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example3] Wrong type in input hash `payload`, " \
              "expected `String` for `number`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
