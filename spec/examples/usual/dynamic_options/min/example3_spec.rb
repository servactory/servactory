# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Min::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data: data
      }
    end

    let(:data) { 10 }

    include_examples "check class info",
                     inputs: %i[data],
                     internals: %i[data],
                     outputs: [:data]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        context "when `data` is `Integer`" do
          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with(10) }
        end

        context "when `data` is `String`" do
          let(:data) { "Sesquipedalianism" }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with("Sesquipedalianism") }
        end

        context "when `data` is `Array`" do
          let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) }
        end

        context "when `data` is `Hash`" do
          let(:data) { { a: 1, b: 2, c: 3, d: 4 } }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with({ a: 1, b: 2, c: 3, d: 4 }) }
        end
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { 0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "The input value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { 1 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { 2 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `String`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { "" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Min::Example3] Required input `data` is missing"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { "S" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { "Se" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { [] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Min::Example3] Required input `data` is missing"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { [0] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { [1, 2] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Hash`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { {} }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Min::Example3] Required input `data` is missing"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { { a: 1 } }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { { a: 1, b: 2 } }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:data).direct(attributes).types(Integer, String, Array, Hash).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        data: data
      }
    end

    let(:data) { 10 }

    include_examples "check class info",
                     inputs: %i[data],
                     internals: %i[data],
                     outputs: [:data]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        context "when `data` is `Integer`" do
          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with(10) }
        end

        context "when `data` is `String`" do
          let(:data) { "Sesquipedalianism" }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with("Sesquipedalianism") }
        end

        context "when `data` is `Array`" do
          let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) }
        end

        context "when `data` is `Hash`" do
          let(:data) { { a: 1, b: 2, c: 3, d: 4 } }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with({ a: 1, b: 2, c: 3, d: 4 }) }
        end
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { 0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "The input value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { 1 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { 2 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `String`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { "" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Min::Example3] Required input `data` is missing"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { "S" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { "Se" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { [] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Min::Example3] Required input `data` is missing"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { [0] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { [1, 2] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Hash`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { {} }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Min::Example3] Required input `data` is missing"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { { a: 1 } }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "The internal value must not be less than the specified value"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { { a: 1, b: 2 } }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "The output value must not be less than the specified value"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:data).direct(attributes).types(Integer, String, Array, Hash).required }
    end
  end
end
