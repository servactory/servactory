# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Time::Optional::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_at:
      }
    end

    let(:started_at) { nil }

    it_behaves_like "check class info",
                    inputs: %i[started_at],
                    internals: %i[],
                    outputs: %i[started_at]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_at?).contains(false) }
        it { expect(perform).to have_output(:started_at).contains(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `time`" do
          let(:started_at) { "2023-04-14 25:70" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Time::Optional::Example1] " \
                "Input `started_at` does not match `time` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_at).valid_with(attributes).type(String).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_at:
      }
    end

    let(:started_at) { nil }

    it_behaves_like "check class info",
                    inputs: %i[started_at],
                    internals: %i[],
                    outputs: %i[started_at]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_at?).contains(false) }
        it { expect(perform).to have_output(:started_at).contains(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `time`" do
          let(:started_at) { "2023-04-14 25:70" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Time::Optional::Example1] " \
                "Input `started_at` does not match `time` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_at).valid_with(attributes).type(String).optional }
    end
  end
end
