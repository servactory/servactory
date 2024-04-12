# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Format::Date::Is::Example3, type: :service do
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
      describe "but the data required for work is invalid" do
        describe "because the format specified is incorrect" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Wrong::DynamicOptions::Format::Date::Is::Example3] " \
                "Unknown `fake` format specified for output attribute `started_on`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_service_input(:started_on).type(String).required }
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
      describe "but the data required for work is invalid" do
        describe "because the format specified is incorrect" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Wrong::DynamicOptions::Format::Date::Is::Example3] " \
                "Unknown `fake` format specified for output attribute `started_on`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_service_input(:started_on).type(String).required }
    end
  end
end
