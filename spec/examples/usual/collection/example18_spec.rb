# frozen_string_literal: true

RSpec.describe Usual::Collection::Example18, type: :service do
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

        it { expect(perform).to have_output(:letters?).with(true) }
        it { expect(perform).to have_output(:letters).with([%w[A B], ["C", "D", %w[E F], nil, ""]]) }
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
                "[Usual::Collection::Example18] Wrong type in input collection `letters`, " \
                "expected `String, NilClass`, got `Symbol`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:letters)
            .valid_with(attributes)
            .type(Array)
            .consists_of(String, NilClass)
            .optional
        )
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

        it { expect(perform).to have_output(:letters?).with(true) }
        it { expect(perform).to have_output(:letters).with([%w[A B], ["C", "D", %w[E F], nil, ""]]) }
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
                "[Usual::Collection::Example18] Wrong type in input collection `letters`, " \
                "expected `String, NilClass`, got `Symbol`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:letters)
            .valid_with(attributes)
            .type(Array)
            .consists_of(String, NilClass)
            .optional
        )
      end
    end
  end
end
