# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example9 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        letters: letters
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F], nil, ""]]
    end

    include_examples "check class info",
                     inputs: %i[letters],
                     internals: %i[letters],
                     outputs: %i[letters desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns expected values", :aggregate_failures do
          result = perform

          expect(result.letters?).to be(true)
          expect(result.letters).to(
            contain_exactly(%w[A B], ["C", "D", %w[E F], nil, ""])
          )
          expect(result.desired_letter?).to be(true)
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
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::ConsistsOf::Example9] Wrong element type in input collection `letters`, " \
                "expected `String, NilClass`, got `Symbol`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `letters`" do
        it_behaves_like "input required check", name: :letters

        it_behaves_like "input type check",
                        name: :letters,
                        expected_type: Array
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
      [%w[A B], ["C", "D", %w[E F], nil, ""]]
    end

    include_examples "check class info",
                     inputs: %i[letters],
                     internals: %i[letters],
                     outputs: %i[letters desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns expected values", :aggregate_failures do
          result = perform

          expect(result.letters?).to be(true)
          expect(result.letters).to(
            contain_exactly(%w[A B], ["C", "D", %w[E F], nil, ""])
          )
          expect(result.desired_letter?).to be(true)
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
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::ConsistsOf::Example9] Wrong element type in input collection `letters`, " \
                "expected `String, NilClass`, got `Symbol`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `letters`" do
        it_behaves_like "input required check", name: :letters

        it_behaves_like "input type check",
                        name: :letters,
                        expected_type: Array
      end
    end
  end
end
