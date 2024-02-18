# frozen_string_literal: true

RSpec.describe Wrong::Prepare::Example3 do
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
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Prepare::Example3] Conflict in `invoice_numbers` input options: `prepare_vs_must`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_numbers`" do
        describe "is not passed" do
          let(:invoice_numbers) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example3] Conflict in `invoice_numbers` input options: `prepare_vs_must`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:invoice_numbers) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example3] Conflict in `invoice_numbers` input options: `prepare_vs_must`"
              )
            )
          end
        end
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
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Prepare::Example3] Conflict in `invoice_numbers` input options: `prepare_vs_must`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_numbers`" do
        describe "is not passed" do
          let(:invoice_numbers) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example3] Conflict in `invoice_numbers` input options: `prepare_vs_must`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:invoice_numbers) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example3] Conflict in `invoice_numbers` input options: `prepare_vs_must`"
              )
            )
          end
        end
      end
    end
  end
end
