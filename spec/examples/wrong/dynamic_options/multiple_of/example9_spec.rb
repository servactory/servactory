# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::MultipleOf::Example9, type: :service do
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
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      context "when `number` is `1`" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example9] " \
              "Input `number` has the value `1`, which is not a multiple of `1.0e+16`"
            )
          )
        end
      end

      context "when `number` is `1.0`" do
        let(:number) { 1.0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example9] " \
              "Input `number` has the value `1.0`, which is not a multiple of `1.0e+16`"
            )
          )
        end
      end

      context "when `number` is `-1.0`" do
        let(:number) { -1.0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example9] " \
              "Input `number` has the value `-1.0`, which is not a multiple of `1.0e+16`"
            )
          )
        end
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
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      context "when `number` is `1`" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example9] " \
              "Input `number` has the value `1`, which is not a multiple of `1.0e+16`"
            )
          )
        end
      end

      context "when `number` is `1.0`" do
        let(:number) { 1.0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example9] " \
              "Input `number` has the value `1.0`, which is not a multiple of `1.0e+16`"
            )
          )
        end
      end

      context "when `number` is `-1.0`" do
        let(:number) { -1.0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example9] " \
              "Input `number` has the value `-1.0`, which is not a multiple of `1.0e+16`"
            )
          )
        end
      end
    end
  end
end
