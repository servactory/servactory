# frozen_string_literal: true

RSpec.describe Usual::Collection::Example17 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        codes: codes
      }
    end

    let(:codes) do
      [%w[A B], ["C", "D", %w[E F]]]
    end

    include_examples "check class info",
                     inputs: %i[codes],
                     internals: %i[codes],
                     outputs: %i[desired_code]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `desired_code`" do
          result = perform

          expect(result.desired_code).to eq("E")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element has the wrong type" do
          let(:codes) do
            [%w[A B], ["C", :D, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Wrong type in input collection `codes`, expected `String`, got `Symbol`"
              )
            )
          end
        end

        describe "because one element is empty" do
          let(:codes) do
            [%w[A B], ["C", "", %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `codes` is missing"
              )
            )
          end
        end

        describe "because one element is nil" do
          let(:codes) do
            [%w[A B], ["C", nil, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `codes` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `codes`" do
        it_behaves_like "input required check", name: :codes

        it_behaves_like "input type check", name: :codes, collection: Array, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        codes: codes
      }
    end

    let(:codes) do
      [%w[A B], ["C", "D", %w[E F]]]
    end

    include_examples "check class info",
                     inputs: %i[codes],
                     internals: %i[codes],
                     outputs: %i[desired_code]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `desired_code`" do
          result = perform

          expect(result.desired_code).to eq("E")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element has the wrong type" do
          let(:codes) do
            [%w[A B], ["C", :D, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Wrong type in input collection `codes`, expected `String`, got `Symbol`"
              )
            )
          end
        end

        describe "because one element is empty" do
          let(:codes) do
            [%w[A B], ["C", "", %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `codes` is missing"
              )
            )
          end
        end

        describe "because one element is nil" do
          let(:codes) do
            [%w[A B], ["C", nil, %w[E F]]]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Collection::Example17] Required element in input collection `codes` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `codes`" do
        it_behaves_like "input required check", name: :codes

        it_behaves_like "input type check", name: :codes, collection: Array, expected_type: String
      end
    end
  end
end
