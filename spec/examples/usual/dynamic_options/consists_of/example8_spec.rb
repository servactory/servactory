# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example8 do
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
                     outputs: %i[letters desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:letters?).with(true) }
        it { expect(perform).to have_output(:letters).with([%w[A B], ["C", "D", %w[E F]]]) }
        it { expect(perform).to have_output(:desired_letter?).with(true) }
        it { expect(perform).to have_output(:desired_letter).with("E") }
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
                "[Usual::DynamicOptions::ConsistsOf::Example8] Wrong element type in input collection `letters`, " \
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
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::ConsistsOf::Example8] Required element in input " \
                "collection `letters` is missing"
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
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::ConsistsOf::Example8] Required element in input " \
                "collection `letters` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:letters).valid_with(attributes).type(Array).consists_of(String).required }
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
                     outputs: %i[letters desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:letters?).with(true) }
        it { expect(perform).to have_output(:letters).with([%w[A B], ["C", "D", %w[E F]]]) }
        it { expect(perform).to have_output(:desired_letter?).with(true) }
        it { expect(perform).to have_output(:desired_letter).with("E") }
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
                "[Usual::DynamicOptions::ConsistsOf::Example8] Wrong element type in input collection `letters`, " \
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
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::ConsistsOf::Example8] Required element in input " \
                "collection `letters` is missing"
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
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::ConsistsOf::Example8] Required element in input " \
                "collection `letters` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:letters).valid_with(attributes).type(Array).consists_of(String).required }
    end
  end
end
