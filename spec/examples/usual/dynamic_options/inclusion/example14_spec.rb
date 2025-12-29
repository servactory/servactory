# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example14, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        level:
      }
    end

    let(:level) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[level],
                    internals: %i[],
                    outputs: %i[level]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:level).contains(3) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `level` is outside range" do
          let(:level) { 10 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example14] Wrong value in `level`, " \
                "must be one of `1..5`, " \
                "got `10`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:level)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(1..5)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        level:
      }
    end

    let(:level) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[level],
                    internals: %i[],
                    outputs: %i[level]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:level).contains(3) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `level` is outside range" do
          let(:level) { 10 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example14] Wrong value in `level`, " \
                "must be one of `1..5`, " \
                "got `10`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:level)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(1..5)
        )
      end
    end
  end
end
