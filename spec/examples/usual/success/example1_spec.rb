# frozen_string_literal: true

RSpec.describe Usual::Success::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number: number
      }
    end

    let(:number) { 1 }

    include_examples "check class info",
                     inputs: %i[number],
                     internals: %i[],
                     outputs: %i[number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `number` has a value for early success" do
          it "returns the expected value in `number`" do
            result = perform

            expect(result.number).to eq(2)
          end
        end

        context "when `number` has no value for early success" do
          let(:number) { 2 }

          it "returns the expected value in `number`" do
            result = perform

            expect(result.number).to eq(16)
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect { perform }.to be_service_input(:number).type(Integer).required
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number: number
      }
    end

    let(:number) { 1 }

    include_examples "check class info",
                     inputs: %i[number],
                     internals: %i[],
                     outputs: %i[number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `number` has a value for early success" do
          it "returns the expected value in `number`" do
            result = perform

            expect(result.number).to eq(2)
          end
        end

        context "when `number` has no value for early success" do
          let(:number) { 2 }

          it "returns the expected value in `number`" do
            result = perform

            expect(result.number).to eq(16)
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect { perform }.to be_service_input(:number).type(Integer).required
      end
    end
  end
end
