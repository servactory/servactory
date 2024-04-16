# frozen_string_literal: true

RSpec.describe Usual::Hash::Example1, type: :service do
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
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:series) { "HR" }
    let(:number) { "88467617508" }

    include_examples "check class info",
                     inputs: %i[payload],
                     internals: %i[payload],
                     outputs: %i[payload full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it do
          expect(perform).to(
            have_output(:payload)
              .with(
                {
                  request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  user: {
                    first_name: "John",
                    middle_name: "Fitzgerald",
                    last_name: "Kennedy",
                    pass: {
                      series: "HR",
                      number: "88467617508"
                    }
                  }
                }
              )
          )
        end

        it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it do
            expect(perform).to(
              have_output(:payload)
                .with(
                  {
                    request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                    user: {
                      first_name: "John",
                      middle_name: nil,
                      last_name: "Kennedy",
                      pass: {
                        series: "HR",
                        number: "88467617508"
                      }
                    }
                  }
                )
            )
          end

          it { expect(perform).to have_output(:full_name).with("John Kennedy") }
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:payload).valid_with(attributes).type(Hash).required }
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
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:series) { "HR" }
    let(:number) { "88467617508" }

    include_examples "check class info",
                     inputs: %i[payload],
                     internals: %i[payload],
                     outputs: %i[payload full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it do
          expect(perform).to(
            have_output(:payload)
              .with(
                {
                  request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  user: {
                    first_name: "John",
                    middle_name: "Fitzgerald",
                    last_name: "Kennedy",
                    pass: {
                      series: "HR",
                      number: "88467617508"
                    }
                  }
                }
              )
          )
        end

        it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it do
            expect(perform).to(
              have_output(:payload)
                .with(
                  {
                    request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                    user: {
                      first_name: "John",
                      middle_name: nil,
                      last_name: "Kennedy",
                      pass: {
                        series: "HR",
                        number: "88467617508"
                      }
                    }
                  }
                )
            )
          end

          it { expect(perform).to have_output(:full_name).with("John Kennedy") }
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:payload).valid_with(attributes).type(Hash).required }
    end
  end
end
