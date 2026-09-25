# frozen_string_literal: true

RSpec.describe Usual::Type::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:,
        options:,
        limit:
      }
    end

    let(:payload) { { id: 1 } }
    let(:options) { { verbose: true } }
    let(:limit) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[payload options limit],
                    internals: %i[],
                    outputs: %i[payload verbose limit]

    describe "info" do
      it "exposes the type option without a message", :aggregate_failures do
        expect(described_class.info.inputs.dig(:payload, :type)).to eq(is: [Hash], message: nil)
        expect(described_class.info.inputs.dig(:options, :type)).to eq(is: [Hash], message: nil)
        expect(described_class.info.inputs.dig(:limit, :type)).to eq(
          is: [Integer],
          message: "Input `limit` must be an Integer"
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:options)
              .valid_with(attributes)
              .type(Hash)
              .optional
              .default({ verbose: false })
          )
        end

        it do
          expect { perform }.to(
            have_input(:limit)
              .type(Integer)
              .message("Input `limit` must be an Integer")
              .optional
              .default(10)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .contains({ id: 1 })
          )
        end

        it do
          expect(perform).to(
            have_output(:verbose)
              .contains(true)
          )
        end

        it do
          expect(perform).to(
            have_output(:limit)
              .contains(5)
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
              payload: { id: 1 },
              verbose: true,
              limit: 5
            )
        )
      end

      describe "and the optional inputs are not passed" do
        let(:attributes) { { payload: } }

        it do
          expect(perform).to(
            be_success_service
              .with_outputs(
                payload: { id: 1 },
                verbose: false,
                limit: 10
              )
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `payload` is not a Hash" do
        let(:payload) { "id=1" }

        it "returns the default message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Type::Example3] Wrong type of input `payload`, expected `Hash`, got `String`"
            )
          )
        end
      end

      describe "because `options` is not a Hash" do
        let(:options) { [:verbose] }

        it "returns the default message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Type::Example3] Wrong type of input `options`, expected `Hash`, got `Array`"
            )
          )
        end
      end

      describe "because `limit` is not an Integer" do
        let(:limit) { "5" }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Input `limit` must be an Integer"
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
        payload:,
        options:,
        limit:
      }
    end

    let(:payload) { { id: 1 } }
    let(:options) { { verbose: true } }
    let(:limit) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[payload options limit],
                    internals: %i[],
                    outputs: %i[payload verbose limit]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              payload: { id: 1 },
              verbose: true,
              limit: 5
            )
        )
      end

      describe "and the optional inputs are not passed" do
        let(:attributes) { { payload: } }

        it do
          expect(perform).to(
            be_success_service
              .with_outputs(
                payload: { id: 1 },
                verbose: false,
                limit: 10
              )
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `payload` is not a Hash" do
        let(:payload) { "id=1" }

        it "returns the default message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Type::Example3] Wrong type of input `payload`, expected `Hash`, got `String`"
            )
          )
        end
      end

      describe "because `options` is not a Hash" do
        let(:options) { [:verbose] }

        it "returns the default message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Type::Example3] Wrong type of input `options`, expected `Hash`, got `Array`"
            )
          )
        end
      end

      describe "because `limit` is not an Integer" do
        let(:limit) { "5" }

        it "returns the custom message" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Input `limit` must be an Integer"
            )
          )
        end
      end
    end
  end
end
