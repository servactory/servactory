# frozen_string_literal: true

RSpec.describe Usual::Type::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: %i[number]

    describe "info" do
      it "exposes the type option with its message", :aggregate_failures do
        expect(described_class.info.inputs.dig(:number, :type)).to eq(
          is: [Integer, Float, String],
          message: "Input `number` must be an Integer, a Float or a String"
        )
        expect(described_class.info.internals.dig(:number, :type)).to eq(
          is: [Integer, Float],
          message: "Internal attribute `number` must be an Integer or a Float"
        )
        expect(described_class.info.outputs.dig(:number, :type)).to eq(
          is: [Integer],
          message: "Output attribute `number` must be an Integer"
        )
      end

      it "keeps the list of types", :aggregate_failures do
        expect(described_class.info.inputs.dig(:number, :types)).to eq([Integer, Float, String])
        expect(described_class.info.internals.dig(:number, :types)).to eq([Integer, Float])
        expect(described_class.info.outputs.dig(:number, :types)).to eq([Integer])
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .types(Integer, Float, String)
              .message("Input `number` must be an Integer, a Float or a String")
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:number)
              .types(Integer, Float)
              .message("Internal attribute `number` must be an Integer or a Float")
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:number, 42)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value does not match the input type" do
        let(:number) { :forty_two }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Input `number` must be an Integer, a Float or a String"
            )
          )
        end
      end

      describe "because the value does not match the internal type" do
        let(:number) { "42" }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Internal attribute `number` must be an Integer or a Float"
            )
          )
        end
      end

      describe "because the value does not match the output type" do
        let(:number) { 42.0 }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output attribute `number` must be an Integer"
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
        number:
      }
    end

    let(:number) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: %i[number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .types(Integer, Float, String)
              .message("Input `number` must be an Integer, a Float or a String")
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:number)
              .types(Integer, Float)
              .message("Internal attribute `number` must be an Integer or a Float")
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:number, 42)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value does not match the input type" do
        let(:number) { :forty_two }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Input `number` must be an Integer, a Float or a String"
            )
          )
        end
      end

      describe "because the value does not match the internal type" do
        let(:number) { "42" }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Internal attribute `number` must be an Integer or a Float"
            )
          )
        end
      end

      describe "because the value does not match the output type" do
        let(:number) { 42.0 }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output attribute `number` must be an Integer"
            )
          )
        end
      end
    end
  end
end
