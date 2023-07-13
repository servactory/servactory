# frozen_string_literal: true

RSpec.describe Usual::Example55 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[],
                     outputs: %i[event]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        describe "and the value of `event_name` is passed" do
          it "returns the expected values", :aggregate_failures do
            result = perform

            expect(result.event).to be_a(Usual::Example55::Event)
            expect(result.event.id).to be_present
            expect(result.event.event_name).to eq("created")
          end
        end

        describe "and the value of `event_name` is not passed" do
          let(:event_name) { nil }

          it "returns the expected values", :aggregate_failures do
            result = perform

            expect(result.event).to be_a(Usual::Example55::Event)
            expect(result.event.id).to be_present
            expect(result.event.event_name).to be_nil
          end
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Example55] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `event_name`" do
        it_behaves_like "input type check", name: :event_name, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[],
                     outputs: %i[event]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        describe "and the value of `event_name` is passed" do
          it "returns the expected values", :aggregate_failures do
            result = perform

            expect(result.event).to be_a(Usual::Example55::Event)
            expect(result.event.id).to be_present
            expect(result.event.event_name).to eq("created")
          end
        end

        describe "and the value of `event_name` is not passed" do
          let(:event_name) { nil }

          it "returns the expected values", :aggregate_failures do
            result = perform

            expect(result.event).to be_a(Usual::Example55::Event)
            expect(result.event.id).to be_present
            expect(result.event.event_name).to be_nil
          end
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Usual::Example55] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `event_name`" do
        it_behaves_like "input type check", name: :event_name, expected_type: String
      end
    end
  end
end
