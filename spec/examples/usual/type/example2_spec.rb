# frozen_string_literal: true

RSpec.describe Usual::Type::Example2, type: :service do
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
      it "exposes the Proc message of the type option", :aggregate_failures do
        expect(described_class.info.inputs.dig(:number, :type)).to match(
          is: [Integer, Float, String],
          message: be_a(Proc)
        )
        expect(described_class.info.internals.dig(:number, :type)).to match(
          is: [Integer, Float],
          message: be_a(Proc)
        )
        expect(described_class.info.outputs.dig(:number, :type)).to match(
          is: [Integer],
          message: be_a(Proc)
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .types(Integer, Float, String)
              .message(be_a(Proc))
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:number)
              .types(Integer, Float)
              .message(be_a(Proc))
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

        it "returns the message built by the Proc" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Type::Example2] Input `number` received `:forty_two` " \
              "of type `Symbol`, expected `Integer, Float, String`"
            )
          )
        end
      end

      describe "because the value does not match the internal type" do
        let(:number) { "42" }

        it "returns the message built by the Proc" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Internal attribute `number` received `\"42\"` of type `String`, expected `Integer, Float`"
            )
          )
        end
      end

      describe "because the value does not match the output type" do
        let(:number) { 42.0 }

        it "returns the message built by the Proc" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output attribute `number` received `42.0` of type `Float`, expected `Integer`"
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
              .types(Integer, Float, String)
              .message(be_a(Proc))
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:number)
              .types(Integer, Float)
              .message(be_a(Proc))
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

        it "returns the message built by the Proc" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Type::Example2] Input `number` received `:forty_two` " \
              "of type `Symbol`, expected `Integer, Float, String`"
            )
          )
        end
      end

      describe "because the value does not match the internal type" do
        let(:number) { "42" }

        it "returns the message built by the Proc" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Internal attribute `number` received `\"42\"` of type `String`, expected `Integer, Float`"
            )
          )
        end
      end

      describe "because the value does not match the output type" do
        let(:number) { 42.0 }

        it "returns the message built by the Proc" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Output attribute `number` received `42.0` of type `Float`, expected `Integer`"
            )
          )
        end
      end
    end
  end
end
