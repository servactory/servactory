# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Format::Date::Is::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_on:
      }
    end

    let(:started_on) { "2023-04-14" }

    it_behaves_like "check class info",
                    inputs: %i[started_on],
                    internals: %i[],
                    outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        describe "because the format specified is incorrect" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Format::Date::Is::Example1] " \
                "Unknown `nil` format specified for input `started_on`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(false).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_on:
      }
    end

    let(:started_on) { "2023-04-14" }

    it_behaves_like "check class info",
                    inputs: %i[started_on],
                    internals: %i[],
                    outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        describe "because the format specified is incorrect" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Format::Date::Is::Example1] " \
                "Unknown `nil` format specified for input `started_on`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(false).type(String).required }
    end
  end
end
