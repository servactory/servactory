# frozen_string_literal: true

RSpec.describe Usual::Must::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_numbers: invoice_numbers
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

    include_examples "check class info",
                     inputs: %i[invoice_numbers],
                     internals: %i[],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.first_invoice_number).to eq("7650AE")
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
                "Wrong IDs in `invoice_numbers`"
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
                "[Usual::Must::Example1] Wrong type in input collection `invoice_numbers`, " \
                "expected `String`, got `Integer`"
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
                "[Usual::Must::Example1] Required element in input collection `invoice_numbers` is missing"
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
                "[Usual::Must::Example1] Required element in input collection `invoice_numbers` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_numbers`" do
        it_behaves_like "input required check", name: :invoice_numbers

        it_behaves_like "input type check",
                        name: :invoice_numbers,
                        expected_type: Array
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_numbers: invoice_numbers
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

    include_examples "check class info",
                     inputs: %i[invoice_numbers],
                     internals: %i[],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.first_invoice_number).to eq("7650AE")
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
                "Wrong IDs in `invoice_numbers`"
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
                "[Usual::Must::Example1] Wrong type in input collection `invoice_numbers`, " \
                "expected `String`, got `Integer`"
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
                "[Usual::Must::Example1] Required element in input collection `invoice_numbers` is missing"
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
                "[Usual::Must::Example1] Required element in input collection `invoice_numbers` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_numbers`" do
        it_behaves_like "input required check", name: :invoice_numbers

        it_behaves_like "input type check",
                        name: :invoice_numbers,
                        expected_type: Array
      end
    end
  end
end
