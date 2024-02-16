# frozen_string_literal: true

RSpec.describe Usual::Success::Example1 do
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

        it "returns the expected value in `number`" do
          result = perform

          expect(result.number).to eq(2)
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :number
        it_behaves_like "input type check", name: :number, expected_type: Integer
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

        it "returns the expected value in `number`" do
          result = perform

          expect(result.number).to eq(2)
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `invoice_number`" do
        it_behaves_like "input required check", name: :number
        it_behaves_like "input type check", name: :number, expected_type: Integer
      end
    end
  end
end
