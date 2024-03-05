# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Min::Example1 do
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
      end

      describe "but the data required for work is invalid" do
        context "when `data` is `Integer`" do
          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              let(:data) { 0 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Errors::InputError,
                    "[Usual::DynamicOptions::Min::Example1] Input attribute `data` " \
                    "received value `0`, which is less than `1`"
                  )
                )
              end
            end

            describe "for `internal` attribute" do
              let(:data) { 2 }

              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Errors::InputError,
                    "[Usual::DynamicOptions::Min::Example1] Input attribute `data` " \
                      "received value `0`, which is less than `1`"
                  )
                )
              end
            end

            describe "for `output` attribute" do
              let(:data) { 2 }
            end
          end
        end

        context "when `data` is `String`" do
          let(:data) { "" }

          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Errors::InputError,
                    "[Usual::DynamicOptions::Min::Example1] Input attribute `data` " \
                    "received value `0`, which is less than `1`"
                  )
                )
              end
            end
          end
        end

        context "when `data` is `Array`" do
          let(:data) { [] }

          describe "because the value is less than specified" do
            describe "for `input` attribute" do
              it "returns expected error" do
                expect { perform }.to(
                  raise_error(
                    ApplicationService::Errors::InputError,
                    "[Usual::DynamicOptions::Min::Example1] Input attribute `data` " \
                    "received value `0`, which is less than `1`"
                  )
                )
              end
            end
          end
        end

        describe "because the value is of the wrong type" do
          let(:number_of_calls) { "10" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::InputOptionHelpers::Example2] Wrong type of input " \
                "`number_of_calls`, expected `Integer`, got `String`"
              )
            )
          end
        end

        describe "because the value is empty" do
          let(:number_of_calls) { "" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::InputOptionHelpers::Example2] Required input `number_of_calls` is missing"
              )
            )
          end
        end

        describe "because the value is nil" do
          let(:number_of_calls) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::InputOptionHelpers::Example2] Required input `number_of_calls` is missing"
              )
            )
          end
        end

        # TODO: Will be added later
        # describe "because the internal attribute does not match due to the fact that the value" do
        #   describe "is less than `2`" do
        #     let(:number_of_calls) { 1 }
        #
        #     it "returns expected error" do
        #       expect { perform }.to(
        #         raise_error(
        #           ApplicationService::Errors::InputError,
        #           "[Usual::InputOptionHelpers::Example2] Required input `number_of_calls` is missing"
        #         )
        #       )
        #     end
        #   end
        #
        #   describe "is greater than `19`" do
        #     let(:number_of_calls) { 20 }
        #
        #     it "returns expected error" do
        #       expect { perform }.to(
        #         raise_error(
        #           ApplicationService::Errors::InputError,
        #           "[Usual::InputOptionHelpers::Example2] Required input `number_of_calls` is missing"
        #         )
        #       )
        #     end
        #   end
        # end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :data

        it_behaves_like "input type check", name: :data, expected_type: [Integer, String, Array]
      end
    end
  end

  # describe ".call" do
  #   subject(:perform) { described_class.call(**attributes) }
  #
  #   let(:attributes) do
  #     {
  #       number_of_calls: number_of_calls
  #     }
  #   end
  #
  #   let(:number_of_calls) { 10 }
  #
  #   include_examples "check class info",
  #                    inputs: %i[number_of_calls],
  #                    internals: %i[number_of_calls],
  #                    outputs: [:number_of_calls]
  #
  #   context "when the input arguments are valid" do
  #     describe "and the data required for work is also valid" do
  #       include_examples "success result class"
  #
  #       it "returns the expected value in `first_id`", :aggregate_failures do
  #         result = perform
  #
  #         expect(result.number_of_calls?).to be(true)
  #         expect(result.number_of_calls).to eq(10)
  #       end
  #     end
  #
  #     describe "but the data required for work is invalid" do
  #       describe "because the value does not correspond to the minimum" do
  #         describe "because `0`" do
  #           let(:number_of_calls) { 0 }
  #
  #           it "returns expected error" do
  #             expect { perform }.to(
  #               raise_error(
  #                 ApplicationService::Errors::InputError,
  #                 "[Usual::InputOptionHelpers::Example2] Input attribute `number_of_calls` " \
  #                 "received value `0`, which is less than `1`"
  #               )
  #             )
  #           end
  #         end
  #
  #         describe "because `-1`" do
  #           let(:number_of_calls) { -1 }
  #
  #           it "returns expected error" do
  #             expect { perform }.to(
  #               raise_error(
  #                 ApplicationService::Errors::InputError,
  #                 "[Usual::InputOptionHelpers::Example2] Input attribute `number_of_calls` " \
  #                 "received value `-1`, which is less than `1`"
  #               )
  #             )
  #           end
  #         end
  #       end
  #
  #       describe "because the value is of the wrong type" do
  #         let(:number_of_calls) { "10" }
  #
  #         it "returns expected error" do
  #           expect { perform }.to(
  #             raise_error(
  #               ApplicationService::Errors::InputError,
  #               "[Usual::InputOptionHelpers::Example2] Wrong type of input " \
  #               "`number_of_calls`, expected `Integer`, got `String`"
  #             )
  #           )
  #         end
  #       end
  #
  #       describe "because the value is empty" do
  #         let(:number_of_calls) { "" }
  #
  #         it "returns expected error" do
  #           expect { perform }.to(
  #             raise_error(
  #               ApplicationService::Errors::InputError,
  #               "[Usual::InputOptionHelpers::Example2] Required input `number_of_calls` is missing"
  #             )
  #           )
  #         end
  #       end
  #
  #       describe "because the value is nil" do
  #         let(:number_of_calls) { nil }
  #
  #         it "returns expected error" do
  #           expect { perform }.to(
  #             raise_error(
  #               ApplicationService::Errors::InputError,
  #               "[Usual::InputOptionHelpers::Example2] Required input `number_of_calls` is missing"
  #             )
  #           )
  #         end
  #       end
  #     end
  #   end
  #
  #   context "when the input arguments are invalid" do
  #     context "when `number_of_calls`" do
  #       it_behaves_like "input required check", name: :number_of_calls
  #
  #       it_behaves_like "input type check", name: :number_of_calls, expected_type: Integer
  #     end
  #   end
  # end
end
