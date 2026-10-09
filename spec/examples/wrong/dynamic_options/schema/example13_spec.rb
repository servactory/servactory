# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example13, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        meta: { a: "ok" },
        name:
      }
    end

    let(:name) { "John" }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  meta: {
                    type: Hash,
                    a: { type: String }
                  },
                  name: { type: String }
                }
              )
              .required
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value type for `name` after a valid nested hash is wrong" do
        let(:name) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Schema::Example13] Wrong type in input hash `payload`, " \
              "expected `String` for `name`, got `Integer`"
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
      {
        meta: { a: "ok" },
        name:
      }
    end

    let(:name) { "John" }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  meta: {
                    type: Hash,
                    a: { type: String }
                  },
                  name: { type: String }
                }
              )
              .required
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value type for `name` after a valid nested hash is wrong" do
        let(:name) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Schema::Example13] Wrong type in input hash `payload`, " \
              "expected `String` for `name`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
