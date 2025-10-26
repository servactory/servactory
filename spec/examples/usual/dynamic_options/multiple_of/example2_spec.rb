# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::MultipleOf::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 90 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: [:number]

    context "when the input arguments are valid" do
      describe "and the number required for work is also valid" do
        it do
          expect(described_class.info.inputs.dig(:number, :must).keys).to(
            contain_exactly(:be_multiple_of)
          )
        end

        it do
          expect(described_class.info.internals.dig(:number, :must).keys).to(
            contain_exactly(:be_divisible_by)
          )
        end

        it do
          expect(described_class.info.outputs.dig(:number, :must).keys).to(
            contain_exactly(:be_multiple_of)
          )
        end

        context "when `number` is `Integer`" do
          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(90) }
        end

        context "when `number` is `Float`" do
          let(:number) { 90.0 }

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(90.0) }
        end

        context "when `number` is `Rational`" do
          let(:number) { Rational(90) }

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(90 / 1) }
        end

        context "when `number` is `BigDecimal`" do
          let(:number) { BigDecimal(90) }

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(0.90e2) } # rubocop:disable Style/ExponentialNotation
        end
      end

      describe "but the number required for work is invalid" do
        context "when `number` is `Integer`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { 12 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { 9 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { 18 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end

        context "when `number` is `Float`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { 12.0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12.0`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { 9.0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9.0`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { 18.0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18.0`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end

        context "when `number` is `Rational`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { Rational(12) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12/1`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { Rational(9) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9/1`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { Rational(18) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18/1`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end

        context "when `number` is `BigDecimal`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { BigDecimal(12) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12.0`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { BigDecimal(9) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9.0`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { BigDecimal(18) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18.0`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number).valid_with(attributes).types(Integer, Float, Rational, BigDecimal).required
        )
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

    let(:number) { 90 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: [:number]

    context "when the input arguments are valid" do
      describe "and the number required for work is also valid" do
        it do
          expect(described_class.info.inputs.dig(:number, :must).keys).to(
            contain_exactly(:be_multiple_of)
          )
        end

        it do
          expect(described_class.info.internals.dig(:number, :must).keys).to(
            contain_exactly(:be_divisible_by)
          )
        end

        it do
          expect(described_class.info.outputs.dig(:number, :must).keys).to(
            contain_exactly(:be_multiple_of)
          )
        end

        context "when `number` is `Integer`" do
          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(90) }
        end

        context "when `number` is `Float`" do
          let(:number) { 90.0 }

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(90.0) }
        end

        context "when `number` is `Rational`" do
          let(:number) { Rational(90) }

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(90 / 1) }
        end

        context "when `number` is `BigDecimal`" do
          let(:number) { BigDecimal(90) }

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:number?).contains(true) }
          it { expect(perform).to have_output(:number).contains(0.90e2) } # rubocop:disable Style/ExponentialNotation
        end
      end

      describe "but the number required for work is invalid" do
        context "when `number` is `Integer`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { 12 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { 9 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { 18 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end

        context "when `number` is `Float`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { 12.0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12.0`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { 9.0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9.0`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { 18.0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18.0`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end

        context "when `number` is `Rational`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { Rational(12) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12/1`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { Rational(9) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9/1`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { Rational(18) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18/1`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end

        context "when `number` is `BigDecimal`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:number) { BigDecimal(12) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "Input `number` has the value `12.0`, which is not a multiple of `9`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:number) { BigDecimal(9) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "Internal `number` has the value `9.0`, which is not a multiple of `6`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:number) { BigDecimal(18) }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "Output `number` has the value `18.0`, which is not a multiple of `5`"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number).valid_with(attributes).types(Integer, Float, Rational, BigDecimal).required
        )
      end
    end
  end
end
