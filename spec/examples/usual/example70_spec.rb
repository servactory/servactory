# frozen_string_literal: true

RSpec.describe Usual::Example70 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload: payload
      }
    end

    let(:payload) do
      {
        request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        user: {
          first_name: first_name,
          middle_name: middle_name,
          last_name: last_name,
          pass: {
            series: series,
            number: number
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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John <unknown> Kennedy")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `payload`" do
        it_behaves_like "input required check", name: :payload
        it_behaves_like "input type check", name: :payload, expected_type: Hash
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        payload: payload
      }
    end

    let(:payload) do
      {
        request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        user: {
          first_name: first_name,
          middle_name: middle_name,
          last_name: last_name,
          pass: {
            series: series,
            number: number
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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John <unknown> Kennedy")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `payload`" do
        it_behaves_like "input required check", name: :payload
        it_behaves_like "input type check", name: :payload, expected_type: Hash
      end
    end
  end
end
