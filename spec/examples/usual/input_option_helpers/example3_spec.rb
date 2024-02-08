# frozen_string_literal: true

RSpec.describe Usual::InputOptionHelpers::Example3 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number_of_calls: number_of_calls
      }
    end

    let(:number_of_calls) { 10 }

    include_examples "check class info",
                     inputs: %i[number_of_calls],
                     internals: %i[number_of_calls],
                     outputs: [:number_of_calls]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`", :aggregate_failures do
          result = perform

          expect(result.number_of_calls?).to be(true)
          expect(result.number_of_calls).to eq(10)
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value does not correspond to the minimum" do
          describe "because `0`" do
            let(:number_of_calls) { 0 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Errors::InputError,
                  "The value of `number_of_calls` must be greater than or equal to `1` (got: `0`)"
                )
              )
            end
          end

          describe "because `-1`" do
            let(:number_of_calls) { -1 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Errors::InputError,
                  "The value of `number_of_calls` must be greater than or equal to `1` (got: `-1`)"
                )
              )
            end
          end
        end

        describe "because the value is of the wrong type" do
          let(:number_of_calls) { "10" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::InputOptionHelpers::Example3] Wrong type of input " \
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
                "[Usual::InputOptionHelpers::Example3] Required input `number_of_calls` is missing"
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
                "[Usual::InputOptionHelpers::Example3] Required input `number_of_calls` is missing"
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
        #           "[Usual::InputOptionHelpers::Example3] Required input `number_of_calls` is missing"
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
        #           "[Usual::InputOptionHelpers::Example3] Required input `number_of_calls` is missing"
        #         )
        #       )
        #     end
        #   end
        # end
      end
    end

    context "when the input arguments are invalid" do
      context "when `number_of_calls`" do
        it_behaves_like "input required check", name: :number_of_calls

        it_behaves_like "input type check", name: :number_of_calls, expected_type: Integer
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number_of_calls: number_of_calls
      }
    end

    let(:number_of_calls) { 10 }

    include_examples "check class info",
                     inputs: %i[number_of_calls],
                     internals: %i[number_of_calls],
                     outputs: [:number_of_calls]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`", :aggregate_failures do
          result = perform

          expect(result.number_of_calls?).to be(true)
          expect(result.number_of_calls).to eq(10)
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value does not correspond to the minimum" do
          describe "because `0`" do
            let(:number_of_calls) { 0 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Errors::InputError,
                  "The value of `number_of_calls` must be greater than or equal to `1` (got: `0`)"
                )
              )
            end
          end

          describe "because `-1`" do
            let(:number_of_calls) { -1 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Errors::InputError,
                  "The value of `number_of_calls` must be greater than or equal to `1` (got: `-1`)"
                )
              )
            end
          end
        end

        describe "because the value is of the wrong type" do
          let(:number_of_calls) { "10" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::InputOptionHelpers::Example3] Wrong type of input " \
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
                "[Usual::InputOptionHelpers::Example3] Required input `number_of_calls` is missing"
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
                "[Usual::InputOptionHelpers::Example3] Required input `number_of_calls` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `number_of_calls`" do
        it_behaves_like "input required check", name: :number_of_calls

        it_behaves_like "input type check", name: :number_of_calls, expected_type: Integer
      end
    end
  end
end
