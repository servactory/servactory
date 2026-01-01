# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Time::Properties::Pattern::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_at:
      }
    end

    let(:started_at) { "08:58:00" }

    it_behaves_like "check class info",
                    inputs: %i[started_at],
                    internals: %i[],
                    outputs: %i[started_at]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected value", :aggregate_failures do
        result = perform

        expect(result.started_at?).to be(true)
        expect(result.started_at).to eq("08:58:00")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `time`" do
        let(:started_at) { "8:58" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Usual::DynamicOptions::Format::Time::Properties::Pattern::Example3] " \
              "Output attribute `started_at` does not match `time` format"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:started_at)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_at:
      }
    end

    let(:started_at) { "08:58:00" }

    it_behaves_like "check class info",
                    inputs: %i[started_at],
                    internals: %i[],
                    outputs: %i[started_at]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected value", :aggregate_failures do
        result = perform

        expect(result.started_at?).to be(true)
        expect(result.started_at).to eq("08:58:00")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `time`" do
        let(:started_at) { "8:58" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Usual::DynamicOptions::Format::Time::Properties::Pattern::Example3] " \
              "Output attribute `started_at` does not match `time` format"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:started_at)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end
    end
  end
end
