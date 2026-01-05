# frozen_string_literal: true

RSpec.describe Usual::Prepare::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        balance_cents:
      }
    end

    let(:balance_cents) { 2_000_00 }

    it_behaves_like "check class info",
                    inputs: %i[balance_cents],
                    internals: %i[],
                    outputs: %i[balance_with_bonus]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:balance_cents)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:balance_with_bonus)
              .instance_of(Usual::Prepare::Example1::Money)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
        )
      end

      it do
        expect(perform).to(
          have_output(:balance_with_bonus)
            .nested(:cents)
            .contains(3_000_00)
        )
      end

      it do
        expect(perform).to(
          have_output(:balance_with_bonus)
            .nested(:currency)
            .contains(:USD)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        balance_cents:
      }
    end

    let(:balance_cents) { 2_000_00 }

    it_behaves_like "check class info",
                    inputs: %i[balance_cents],
                    internals: %i[],
                    outputs: %i[balance_with_bonus]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:balance_cents)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:balance_with_bonus)
              .instance_of(Usual::Prepare::Example1::Money)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
        )
      end

      it do
        expect(perform).to(
          have_output(:balance_with_bonus)
            .nested(:cents)
            .contains(3_000_00)
        )
      end

      it do
        expect(perform).to(
          have_output(:balance_with_bonus)
            .nested(:currency)
            .contains(:USD)
        )
      end
    end
  end
end
