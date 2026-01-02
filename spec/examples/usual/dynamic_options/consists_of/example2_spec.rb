# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_numbers:
      }
    end

    let(:invoice_numbers) do
      %w[
        7650AE
        B4EA1B
        A7BC86
        BD2D6B
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[invoice_numbers],
                    internals: %i[],
                    outputs: %i[first_invoice_number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_numbers)
              .valid_with(attributes)
              .type(Array)
              .required
              .consists_of(String)
              .must(:be_6_characters)
          )
        end
      end
    end

    describe "outputs" do
      it do
        expect(perform).to(
          have_output(:first_invoice_number)
            .instance_of(String)
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              first_invoice_number: "7650AE",
              first_invoice_number?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element does not match the condition" do
        let(:invoice_numbers) do
          %w[
            7650AE
            B4EA1B
            A7BC86XXX
            BD2D6B
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Input `invoice_numbers` must \"be_6_characters\""
            )
          )
        end
      end

      describe "because one element has the wrong type" do
        let(:invoice_numbers) do
          [
            "7650AE",
            123_456,
            "A7BC86"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Wrong element type in input " \
              "collection `invoice_numbers`, expected `String`, got `Integer`"
            )
          )
        end
      end

      describe "because one element is empty" do
        let(:invoice_numbers) do
          [
            "7650AE",
            "",
            "A7BC86"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Required element in input " \
              "collection `invoice_numbers` is missing"
            )
          )
        end
      end

      describe "because one element is nil" do
        let(:invoice_numbers) do
          [
            "7650AE",
            nil,
            "A7BC86"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Required element in input " \
              "collection `invoice_numbers` is missing"
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
        invoice_numbers:
      }
    end

    let(:invoice_numbers) do
      %w[
        7650AE
        B4EA1B
        A7BC86
        BD2D6B
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[invoice_numbers],
                    internals: %i[],
                    outputs: %i[first_invoice_number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_numbers)
              .valid_with(attributes)
              .type(Array)
              .required
              .consists_of(String)
              .must(:be_6_characters)
          )
        end
      end
    end

    describe "outputs" do
      it do
        expect(perform).to(
          have_output(:first_invoice_number)
            .instance_of(String)
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              first_invoice_number: "7650AE",
              first_invoice_number?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element does not match the condition" do
        let(:invoice_numbers) do
          %w[
            7650AE
            B4EA1B
            A7BC86XXX
            BD2D6B
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Input `invoice_numbers` must \"be_6_characters\""
            )
          )
        end
      end

      describe "because one element has the wrong type" do
        let(:invoice_numbers) do
          [
            "7650AE",
            123_456,
            "A7BC86"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Wrong element type in input " \
              "collection `invoice_numbers`, expected `String`, got `Integer`"
            )
          )
        end
      end

      describe "because one element is empty" do
        let(:invoice_numbers) do
          [
            "7650AE",
            "",
            "A7BC86"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Required element in input " \
              "collection `invoice_numbers` is missing"
            )
          )
        end
      end

      describe "because one element is nil" do
        let(:invoice_numbers) do
          [
            "7650AE",
            nil,
            "A7BC86"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example2] Required element in input " \
              "collection `invoice_numbers` is missing"
            )
          )
        end
      end
    end
  end
end
