# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Min::Example2, type: :service do
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

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq(10)
          end
        end

        context "when `data` is `String`" do
          let(:data) { "Sesquipedalianism" }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq("Sesquipedalianism")
          end
        end

        context "when `data` is `Array`" do
          let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
          end
        end

        context "when `data` is `Hash`" do
          let(:data) { { a: 1, b: 2, c: 3, d: 4 } }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to match({ a: 1, b: 2, c: 3, d: 4 })
          end
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
                    "The size of the `data` value must be greater than or equal to `1` (got: `0`)"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `1`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `2`)"
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
                    "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `S`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `Se`)"
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
                    "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `[0]`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `[1, 2]`)"
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
                    "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `{:a=>1}`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `{:a=>1, :b=>2}`)"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_service_input(:data).types(Integer, String, Array, Hash).required }
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

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq(10)
          end
        end

        context "when `data` is `String`" do
          let(:data) { "Sesquipedalianism" }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq("Sesquipedalianism")
          end
        end

        context "when `data` is `Array`" do
          let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
          end
        end

        context "when `data` is `Hash`" do
          let(:data) { { a: 1, b: 2, c: 3, d: 4 } }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to match({ a: 1, b: 2, c: 3, d: 4 })
          end
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
                    "The size of the `data` value must be greater than or equal to `1` (got: `0`)"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `1`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `2`)"
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
                    "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `S`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `Se`)"
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
                    "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `[0]`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `[1, 2]`)"
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
                    "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
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
                    "The size of the `data` value must be greater than or equal to `2` (got: `{:a=>1}`)"
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
                    "The size of the `data` value must be greater than or equal to `3` (got: `{:a=>1, :b=>2}`)"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_service_input(:data).types(Integer, String, Array, Hash).required }
    end
  end
end
