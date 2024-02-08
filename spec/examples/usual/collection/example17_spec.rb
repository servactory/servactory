# frozen_string_literal: true

RSpec.describe Usual::Collection::Example17 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        letters: letters
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F]]]
    end

    include_examples "check class info",
                     inputs: %i[letters],
                     internals: %i[letters],
                     outputs: %i[desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `desired_letter`" do
          result = perform

          expect(result.desired_letter).to eq("E")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element has the wrong type" do
          let(:letters) do
            [%w[A B], ["C", :D, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Wrong type in input collection `letters`, " \
                "expected `String`, got `Symbol`"
              )
            )
          end
        end

        describe "because one element is empty" do
          let(:letters) do
            [%w[A B], ["C", "", %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `letters` is missing"
              )
            )
          end
        end

        describe "because one element is nil" do
          let(:letters) do
            [%w[A B], ["C", nil, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `letters` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `letters`" do
        it_behaves_like "input required check", name: :letters

        it_behaves_like "input type check", name: :letters, collection: Array, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        letters: letters
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F]]]
    end

    include_examples "check class info",
                     inputs: %i[letters],
                     internals: %i[letters],
                     outputs: %i[desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `desired_letter`" do
          result = perform

          expect(result.desired_letter).to eq("E")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element has the wrong type" do
          let(:letters) do
            [%w[A B], ["C", :D, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Wrong type in input collection `letters`, " \
                "expected `String`, got `Symbol`"
              )
            )
          end
        end

        describe "because one element is empty" do
          let(:letters) do
            [%w[A B], ["C", "", %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `letters` is missing"
              )
            )
          end
        end

        describe "because one element is nil" do
          let(:letters) do
            [%w[A B], ["C", nil, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `letters` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `letters`" do
        it_behaves_like "input required check", name: :letters

        it_behaves_like "input type check", name: :letters, collection: Array, expected_type: String
      end
    end
  end
end
