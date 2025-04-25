# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        letters:
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F], nil, ""]]
    end

    it_behaves_like "check class info",
                    inputs: %i[letters],
                    internals: %i[letters],
                    outputs: %i[letters desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:letters?).contains(true) }
        it { expect(perform).to have_output(:letters).contains([%w[A B], ["C", "D", %w[E F], nil, ""]]) }
        it { expect(perform).to have_output(:desired_letter?).contains(true) }
        it { expect(perform).to have_output(:desired_letter).contains("E") }
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
      it do
        expect { perform }.to(
          have_input(:letters)
            .valid_with(attributes)
            .type(Array)
            .consists_of(String, NilClass)
            .required
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        letters:
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F], nil, ""]]
    end

    it_behaves_like "check class info",
                    inputs: %i[letters],
                    internals: %i[letters],
                    outputs: %i[letters desired_letter]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:letters?).contains(true) }
        it { expect(perform).to have_output(:letters).contains([%w[A B], ["C", "D", %w[E F], nil, ""]]) }
        it { expect(perform).to have_output(:desired_letter?).contains(true) }
        it { expect(perform).to have_output(:desired_letter).contains("E") }
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
      it do
        expect { perform }.to(
          have_input(:letters)
            .valid_with(attributes)
            .type(Array)
            .consists_of(String, NilClass)
            .required
        )
      end
    end
  end
end
