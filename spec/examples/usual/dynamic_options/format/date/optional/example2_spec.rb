# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Date::Optional::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_on: started_on
      }
    end

    let(:started_on) { nil }

    include_examples "check class info",
                     inputs: %i[started_on],
                     internals: %i[started_on],
                     outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_on?).with(false) }
        it { expect(perform).to have_output(:started_on).with(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Date::Optional::Example2] Internal attribute `started_on` " \
                "does not match `date` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(attributes).type(String).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_on: started_on
      }
    end

    let(:started_on) { nil }

    include_examples "check class info",
                     inputs: %i[started_on],
                     internals: %i[started_on],
                     outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_on?).with(false) }
        it { expect(perform).to have_output(:started_on).with(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Date::Optional::Example2] Internal attribute `started_on` " \
                "does not match `date` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(attributes).type(String).optional }
    end
  end
end