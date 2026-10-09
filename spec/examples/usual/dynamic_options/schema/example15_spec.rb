# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example15, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) { { name: "John" } }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[payload]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  name: { type: String },
                  options: {
                    type: Hash,
                    required: false,
                    default: {},
                    mode: { type: String, required: false, default: "light" }
                  }
                }
              )
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `options` is not passed" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { name: "John", options: { mode: "light" } })
          )
        end

        it "does not modify the default" do
          perform

          expect(described_class::OPTIONS_DEFAULT).to be_frozen.and(be_empty)
        end

        it "returns independent values for consecutive calls" do
          first_payload = perform.payload
          first_payload[:options][:mode] = "dark"

          expect(described_class.call!(payload: { name: "Jane" })).to(
            be_success_service
              .with_output(:payload, { name: "Jane", options: { mode: "light" } })
          )
        end
      end

      context "when `options` is passed" do
        let(:payload) { { name: "John", options: { mode: "dark" } } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { name: "John", options: { mode: "dark" } })
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

    let(:payload) { { name: "John" } }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[payload]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  name: { type: String },
                  options: {
                    type: Hash,
                    required: false,
                    default: {},
                    mode: { type: String, required: false, default: "light" }
                  }
                }
              )
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `options` is not passed" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { name: "John", options: { mode: "light" } })
          )
        end

        it "does not modify the default" do
          perform

          expect(described_class::OPTIONS_DEFAULT).to be_frozen.and(be_empty)
        end

        it "returns independent values for consecutive calls" do
          first_payload = perform.payload
          first_payload[:options][:mode] = "dark"

          expect(described_class.call(payload: { name: "Jane" })).to(
            be_success_service
              .with_output(:payload, { name: "Jane", options: { mode: "light" } })
          )
        end
      end

      context "when `options` is passed" do
        let(:payload) { { name: "John", options: { mode: "dark" } } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { name: "John", options: { mode: "dark" } })
          )
        end
      end
    end
  end
end
