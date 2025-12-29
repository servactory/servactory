# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example15, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        score:
      }
    end

    let(:score) { 75 }

    it_behaves_like "check class info",
                    inputs: %i[score],
                    internals: %i[],
                    outputs: %i[score]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:score).contains(75) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `score` is outside range" do
          let(:score) { 150 }

          it "returns expected error with custom message" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "Score 150 must be between 0 and 100"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:score)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(0..100)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        score:
      }
    end

    let(:score) { 75 }

    it_behaves_like "check class info",
                    inputs: %i[score],
                    internals: %i[],
                    outputs: %i[score]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:score).contains(75) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `score` is outside range" do
          let(:score) { 150 }

          it "returns expected error with custom message" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "Score 150 must be between 0 and 100"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:score)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(0..100)
        )
      end
    end
  end
end
