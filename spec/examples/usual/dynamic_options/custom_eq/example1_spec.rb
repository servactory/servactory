# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::CustomEq::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data: data
      }
    end

    let(:data) { 2 }

    include_examples "check class info",
                     inputs: %i[data],
                     internals: %i[data],
                     outputs: [:data]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        context "when `data` is `Integer`" do
          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with(2) }
        end

        context "when `data` is `String`" do
          let(:data) { "Hi" }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with("Hi") }
        end

        context "when `data` is `Array`" do
          let(:data) { [0, 1] }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq([0, 1])
          end
        end

        context "when `data` is `Hash`" do
          let(:data) { { a: 1, b: 2 } }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with({ a: 1, b: 2 }) }
        end
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { 1 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `1`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `String`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { "Data" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `Data`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { [0] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `[0]`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Hash`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { { a: 1 } }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `{:a=>1}`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:data).valid_with(attributes).types(Integer, String, Array, Hash).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        data: data
      }
    end

    let(:data) { 2 }

    include_examples "check class info",
                     inputs: %i[data],
                     internals: %i[data],
                     outputs: [:data]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        context "when `data` is `Integer`" do
          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with(2) }
        end

        context "when `data` is `String`" do
          let(:data) { "Hi" }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with("Hi") }
        end

        context "when `data` is `Array`" do
          let(:data) { [0, 1] }

          include_examples "success result class"

          it "returns the expected value", :aggregate_failures do
            result = perform

            expect(result.data?).to be(true)
            expect(result.data).to eq([0, 1])
          end
        end

        context "when `data` is `Hash`" do
          let(:data) { { a: 1, b: 2 } }

          include_examples "success result class"

          it { expect(perform).to have_output(:data?).with(true) }
          it { expect(perform).to have_output(:data).with({ a: 1, b: 2 }) }
        end
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { 1 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `1`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `String`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { "Data" }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `Data`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          describe "because the value is greater than specified" do
            describe "for `input` attribute" do
              let(:data) { [0] }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `[0]`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Hash`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { { a: 1 } }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Exceptions::Input,
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                    "received value `{:a=>1}`, which is not equivalent to `2`"
                  )
                )
              end
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:data).valid_with(attributes).types(Integer, String, Array, Hash).required }
    end
  end
end
