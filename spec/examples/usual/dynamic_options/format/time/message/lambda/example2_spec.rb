# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Time::Message::Lambda::Example2, type: :service do
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
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.started_at?).to be(true)
          expect(result.started_at).to eq(Time.parse(started_at))
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `time`" do
          let(:started_at) { "2023-04-14 26:70" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Value `2023-04-14 26:70` does not match the format of `time` in `started_at`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :started_at

        it_behaves_like "input type check", name: :started_at, expected_type: String
      end
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
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.started_at?).to be(true)
          expect(result.started_at).to eq(Time.parse(started_at))
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `time`" do
          let(:started_at) { "2023-04-14 26:70" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Value `2023-04-14 26:70` does not match the format of `time` in `started_at`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :started_at

        it_behaves_like "input type check", name: :started_at, expected_type: String
      end
    end
  end
end
