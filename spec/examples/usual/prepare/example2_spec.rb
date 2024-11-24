# frozen_string_literal: true

RSpec.describe Usual::Prepare::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:,
        preparation_enabled:
      }
    end

    let(:number) { "6" }
    let(:preparation_enabled) { true }

    include_examples "check class info",
                     inputs: %i[number preparation_enabled],
                     internals: %i[],
                     outputs: [:number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when preparation is enabled" do
          it { expect(perform).to have_output(:number).contains(6) }
        end

        context "when preparation is disabled" do
          let(:preparation_enabled) { false }

          it { expect(perform).to have_output(:number).contains("6") }
        end
      end
    end

    context "when the input arguments are invalid" do
      it {
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .types(Integer, String)
            .required
        )
      }

      it {
        expect { perform }.to(
          have_input(:preparation_enabled)
            .valid_with(attributes)
            .types(TrueClass, FalseClass)
            .optional
            .default(true)
        )
      }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number:,
        preparation_enabled:
      }
    end

    let(:number) { "6" }
    let(:preparation_enabled) { true }

    include_examples "check class info",
                     inputs: %i[number preparation_enabled],
                     internals: %i[],
                     outputs: [:number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when preparation is enabled" do
          it { expect(perform).to have_output(:number).contains(6) }
        end

        context "when preparation is disabled" do
          let(:preparation_enabled) { false }

          it { expect(perform).to have_output(:number).contains("6") }
        end
      end
    end

    context "when the input arguments are invalid" do
      it {
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .types(Integer, String)
            .required
        )
      }

      it {
        expect { perform }.to(
          have_input(:preparation_enabled)
            .valid_with(attributes)
            .types(TrueClass, FalseClass)
            .optional
            .default(true)
        )
      }
    end
  end
end
