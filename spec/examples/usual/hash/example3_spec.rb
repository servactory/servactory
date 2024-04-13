# frozen_string_literal: true

RSpec.describe Usual::Hash::Example3, type: :service do
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

        it { expect(perform).to have_output(:full_name).with("John <unknown> Kennedy") }
      end

      describe "but the data required for work is invalid" do
        describe "because one of the values is of the wrong type" do
          let(:number) { 88_467_617_508 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Hash::Example3] Wrong type in input hash `payload`, " \
                "expected `String` for `number`, got `Integer`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:payload).type(Hash).required }
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

        it { expect(perform).to have_output(:full_name).with("John <unknown> Kennedy") }
      end

      describe "but the data required for work is invalid" do
        describe "because one of the values is of the wrong type" do
          let(:number) { 88_467_617_508 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Hash::Example3] Wrong type in input hash `payload`, " \
                "expected `String` for `number`, got `Integer`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:payload).type(Hash).required }
    end
  end
end
