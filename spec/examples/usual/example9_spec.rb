# frozen_string_literal: true

RSpec.describe Usual::Example9 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "created" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.event).to be_a(Usual::Example9::Event)
          expect(result.event.id).to be_present
          expect(result.event.event_name).to eq("created")
          expect(result.success?).to be(true)
          expect(result.failure?).to be(false)
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "[Usual::Example9] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end

        describe "because the value of `event_name` is currently not usable" do
          let(:event_name) { "rejected" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "The `rejected` event cannot be used now"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `event_name`" do
        it_behaves_like "input required check", name: :event_name

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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.event).to be_a(Usual::Example9::Event)
          expect(result.event.id).to be_present
          expect(result.event.event_name).to eq("created")
          expect(result.success?).to be(true)
          expect(result.failure?).to be(false)
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "[Usual::Example9] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end

        describe "because the value of `event_name` is currently not usable" do
          let(:event_name) { "rejected" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "The `rejected` event cannot be used now"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `event_name`" do
        it_behaves_like "input required check", name: :event_name

        it_behaves_like "input type check", name: :event_name, expected_type: String
      end
    end
  end
end
