# frozen_string_literal: true

RSpec.describe Usual::Success::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[],
                    outputs: %i[number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `number` has a value for early success" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 2)
          )
        end
      end

      context "when `number` has no value for early success" do
        let(:number) { 2 }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 16)
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[],
                    outputs: %i[number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `number` has a value for early success" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 2)
          )
        end
      end

      context "when `number` has no value for early success" do
        let(:number) { 2 }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 16)
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end
end
