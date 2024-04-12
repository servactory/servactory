# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Date::Is::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_on: started_on
      }
    end

    let(:started_on) { "2023-04-14" }

    include_examples "check class info",
                     inputs: %i[started_on],
                     internals: %i[],
                     outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.started_on?).to be(true)
          expect(result.started_on).to eq("2023-04-14")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::Format::Date::Is::Example3] Output attribute `started_on` " \
                "does not match `date` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect(perform).to have_input(:started_on).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_on: started_on
      }
    end

    let(:started_on) { "2023-04-14" }

    include_examples "check class info",
                     inputs: %i[started_on],
                     internals: %i[],
                     outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.started_on?).to be(true)
          expect(result.started_on).to eq("2023-04-14")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::Format::Date::Is::Example3] Output attribute `started_on` " \
                "does not match `date` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect(perform).to have_input(:started_on).type(String).required }
    end
  end
end
