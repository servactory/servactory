# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Format::Date::Message::Example3 do
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
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :started_on

        it_behaves_like "input type check", name: :started_on, expected_type: String
      end
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
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :started_on

        it_behaves_like "input type check", name: :started_on, expected_type: String
      end
    end
  end
end
