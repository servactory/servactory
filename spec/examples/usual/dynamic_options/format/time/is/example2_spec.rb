# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Time::Is::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_at: started_at
      }
    end

    let(:started_at) { "2023-04-14 8:58" }

    include_examples "check class info",
                     inputs: %i[started_at],
                     internals: %i[started_at],
                     outputs: %i[started_at]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_at?).with(true) }
        it { expect(perform).to have_output(:started_at).with(Time.parse(started_at)) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `time`" do
          let(:started_at) { "2023-04-14 26:70" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Time::Is::Example2] " \
                "Internal attribute `started_at` does not match `time` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_at).direct(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_at: started_at
      }
    end

    let(:started_at) { "2023-04-14 8:58" }

    include_examples "check class info",
                     inputs: %i[started_at],
                     internals: %i[started_at],
                     outputs: %i[started_at]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_at?).with(true) }
        it { expect(perform).to have_output(:started_at).with(Time.parse(started_at)) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `time`" do
          let(:started_at) { "2023-04-14 26:70" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Time::Is::Example2] " \
                "Internal attribute `started_at` does not match `time` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_at).direct(attributes).type(String).required }
    end
  end
end
