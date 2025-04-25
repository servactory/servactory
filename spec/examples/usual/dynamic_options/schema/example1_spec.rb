# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example1, type: :service do
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
  let(:middle_name) { "Fitzgerald" }
  let(:last_name) { "Kennedy" }
  let(:series) { "HR" }
  let(:number) { "88467617508" }

  it_behaves_like "check class info",
                  inputs: %i[payload],
                  internals: %i[payload],
                  outputs: %i[payload full_name]

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
                  middle_name: { type: String, required: false },
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
                    default: {},
                    visited_on: { type: Date, required: false, default: nil }
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
                  middle_name: { type: String, required: false },
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
                    default: {},
                    visited_on: { type: Date, required: false, default: nil }
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
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:payload)
            .contains(
              {
                request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                user: {
                  first_name: "John",
                  middle_name: "Fitzgerald",
                  last_name: "Kennedy",
                  passport: {
                    series: "HR",
                    number: "88467617508"
                  },
                  session: {}
                }
              }
            )
        )
      end

      it { expect(perform).to have_output(:full_name).contains("John Fitzgerald Kennedy") }

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            have_output(:payload)
              .contains(
                {
                  request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  user: {
                    first_name: "John",
                    middle_name: nil,
                    last_name: "Kennedy",
                    passport: {
                      series: "HR",
                      number: "88467617508"
                    },
                    session: {}
                  }
                }
              )
          )
        end

        it { expect(perform).to have_output(:full_name).contains("John Kennedy") }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:payload)
            .contains(
              {
                request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                user: {
                  first_name: "John",
                  middle_name: "Fitzgerald",
                  last_name: "Kennedy",
                  passport: {
                    series: "HR",
                    number: "88467617508"
                  },
                  session: {}
                }
              }
            )
        )
      end

      it { expect(perform).to have_output(:full_name).contains("John Fitzgerald Kennedy") }

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            have_output(:payload)
              .contains(
                {
                  request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  user: {
                    first_name: "John",
                    middle_name: nil,
                    last_name: "Kennedy",
                    passport: {
                      series: "HR",
                      number: "88467617508"
                    },
                    session: {}
                  }
                }
              )
          )
        end

        it { expect(perform).to have_output(:full_name).contains("John Kennedy") }
      end
    end
  end
end
