# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example16, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      Usual::DynamicOptions::Schema::Example16Payload.new(first_name: "John")
    end

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
              .type(Usual::DynamicOptions::Schema::Example16Payload)
              .schema(
                {
                  first_name: { type: String },
                  middle_name: { type: String, required: false, default: "Unknown" }
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
              .instance_of(Usual::DynamicOptions::Schema::Example16Payload)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              payload:,
              payload?: true
            )
        )
      end

      it "applies default values from the schema" do
        expect(perform.payload[:middle_name]).to eq("Unknown")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `first_name` has the wrong type" do
        let(:payload) do
          Usual::DynamicOptions::Schema::Example16Payload.new(first_name: 123)
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example16] Wrong type in input hash `payload`, " \
              "expected `String` for `first_name`, got `Integer`"
            )
          )
        end
      end

      describe "because `first_name` is missing" do
        let(:payload) do
          Usual::DynamicOptions::Schema::Example16Payload.new
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example16] Wrong type in input hash `payload`, " \
              "expected `String` for `first_name`, got `NilClass`"
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
      Usual::DynamicOptions::Schema::Example16Payload.new(first_name: "John")
    end

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
              .type(Usual::DynamicOptions::Schema::Example16Payload)
              .schema(
                {
                  first_name: { type: String },
                  middle_name: { type: String, required: false, default: "Unknown" }
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
              .instance_of(Usual::DynamicOptions::Schema::Example16Payload)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              payload:,
              payload?: true
            )
        )
      end

      it "applies default values from the schema" do
        expect(perform.payload[:middle_name]).to eq("Unknown")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `first_name` has the wrong type" do
        let(:payload) do
          Usual::DynamicOptions::Schema::Example16Payload.new(first_name: 123)
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example16] Wrong type in input hash `payload`, " \
              "expected `String` for `first_name`, got `Integer`"
            )
          )
        end
      end

      describe "because `first_name` is missing" do
        let(:payload) do
          Usual::DynamicOptions::Schema::Example16Payload.new
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Schema::Example16] Wrong type in input hash `payload`, " \
              "expected `String` for `first_name`, got `NilClass`"
            )
          )
        end
      end
    end
  end
end
