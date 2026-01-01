# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example7, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      nil
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[full_name]

    describe "validations" do
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
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
              .optional
          )
        end
      end

      describe "internals" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_internal(:payload)
              .types(NilClass, Hash)
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
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(NilClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, nil)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one of the values is of the wrong type" do
        let(:payload) { 88_467_617_508 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example7] " \
              "Wrong type of input `payload`, expected `Hash`, got `Integer`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      nil
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[full_name]

    describe "validations" do
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
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
              .optional
          )
        end
      end

      describe "internals" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_internal(:payload)
              .types(NilClass, Hash)
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
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(NilClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, nil)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one of the values is of the wrong type" do
        let(:payload) { 88_467_617_508 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example7] " \
              "Wrong type of input `payload`, expected `Hash`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
