# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Inclusion::Example7, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        value:
      }
    end

    let(:value) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[value]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:value).contains(5) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value is below range" do
          let(:value) { 0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Inclusion::Example7] Wrong value in `value`, " \
                "must be one of `1..10`, " \
                "got `0`"
              )
            )
          end
        end

        describe "because the value is above range" do
          let(:value) { 15 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Inclusion::Example7] Wrong value in `value`, " \
                "must be one of `1..10`, " \
                "got `15`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:value)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(1..10)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        value:
      }
    end

    let(:value) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[value]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:value).contains(5) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value is below range" do
          let(:value) { 0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Inclusion::Example7] Wrong value in `value`, " \
                "must be one of `1..10`, " \
                "got `0`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:value)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(1..10)
        )
      end
    end
  end
end
