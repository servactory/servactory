# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example12, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) { Hash.new(0).merge!(first_name: "John") }

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
                  first_name: { type: String, required: true },
                  middle_name: { type: String, required: false, default: "Unknown" },
                  nicknames: { type: Array, required: false }
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
      context "when `payload` has a default value" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { first_name: "John", middle_name: "Unknown" })
          )
        end
      end

      context "when `payload` has a default proc" do
        let(:payload) do
          Hash.new { |hash, key| hash[key] = "generated" }.merge!(first_name: "John")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { first_name: "John", middle_name: "Unknown" })
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

    let(:payload) { Hash.new(0).merge!(first_name: "John") }

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
                  first_name: { type: String, required: true },
                  middle_name: { type: String, required: false, default: "Unknown" },
                  nicknames: { type: Array, required: false }
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
      context "when `payload` has a default value" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { first_name: "John", middle_name: "Unknown" })
          )
        end
      end

      context "when `payload` has a default proc" do
        let(:payload) do
          Hash.new { |hash, key| hash[key] = "generated" }.merge!(first_name: "John")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, { first_name: "John", middle_name: "Unknown" })
          )
        end
      end
    end
  end
end
