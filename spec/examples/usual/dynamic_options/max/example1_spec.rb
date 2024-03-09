# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Max::Example1 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data: data
      }
    end

    let(:data) { 1 }

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
            expect(result.data).to eq(1)
          end
        end

        context "when `data` is `String`" do
          let(:data) { "Data" }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq("Data")
          end
        end

        context "when `data` is `Array`" do
          let(:data) { [0] }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq([0])
          end
        end
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { 11 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Max::Example1] Input attribute `data` " \
                    "received value `11`, which is greater than `10`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { 10 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "[Usual::DynamicOptions::Max::Example1] Internal attribute `data` " \
                    "received value `10`, which is greater than `9`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { 9 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "[Usual::DynamicOptions::Max::Example1] Output attribute `data` " \
                    "received value `9`, which is greater than `8`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `String`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { "Sesquipedalianism" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Max::Example1] Input attribute `data` " \
                    "received value `Sesquipedalianism`, which is greater than `10`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { "Alexandria" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "[Usual::DynamicOptions::Max::Example1] Internal attribute `data` " \
                    "received value `Alexandria`, which is greater than `9`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { "Strengths" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "[Usual::DynamicOptions::Max::Example1] Output attribute `data` " \
                    "received value `Strengths`, which is greater than `8`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Max::Example1] Input attribute `data` " \
                    "received value `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`, which is greater than `10`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "[Usual::DynamicOptions::Max::Example1] Internal attribute `data` " \
                    "received value `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`, which is greater than `9`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "[Usual::DynamicOptions::Max::Example1] Output attribute `data` " \
                    "received value `[0, 1, 2, 3, 4, 5, 6, 7, 8]`, which is greater than `8`"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :data

        it_behaves_like "input type check", name: :data, expected_type: [Integer, String, Array]
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        data: data
      }
    end

    let(:data) { 1 }

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
            expect(result.data).to eq(1)
          end
        end

        context "when `data` is `String`" do
          let(:data) { "Data" }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq("Data")
          end
        end

        context "when `data` is `Array`" do
          let(:data) { [0] }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq([0])
          end
        end
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { 11 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Max::Example1] Input attribute `data` " \
                    "received value `11`, which is greater than `10`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { 10 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "[Usual::DynamicOptions::Max::Example1] Internal attribute `data` " \
                    "received value `10`, which is greater than `9`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { 9 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "[Usual::DynamicOptions::Max::Example1] Output attribute `data` " \
                    "received value `9`, which is greater than `8`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `String`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { "Sesquipedalianism" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Max::Example1] Input attribute `data` " \
                    "received value `Sesquipedalianism`, which is greater than `10`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { "Alexandria" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "[Usual::DynamicOptions::Max::Example1] Internal attribute `data` " \
                    "received value `Alexandria`, which is greater than `9`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { "Strengths" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "[Usual::DynamicOptions::Max::Example1] Output attribute `data` " \
                    "received value `Strengths`, which is greater than `8`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::Max::Example1] Input attribute `data` " \
                    "received value `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`, which is greater than `10`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Internal,
                    "[Usual::DynamicOptions::Max::Example1] Internal attribute `data` " \
                    "received value `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`, which is greater than `9`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Output,
                    "[Usual::DynamicOptions::Max::Example1] Output attribute `data` " \
                    "received value `[0, 1, 2, 3, 4, 5, 6, 7, 8]`, which is greater than `8`"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :data

        it_behaves_like "input type check", name: :data, expected_type: [Integer, String, Array]
      end
    end
  end
end
