# frozen_string_literal: true

RSpec.describe Usual::Extensions::PostCondition::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[total]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:amount)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          result = perform
          expect(result.total).to be_a(Integer)
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with calculated total" do
        expect(perform).to be_success_service
        expect(perform.total).to eq(200)
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with calculated total" do
        expect(perform).to be_success_service
        expect(perform.total).to eq(200)
      end
    end
  end
end
