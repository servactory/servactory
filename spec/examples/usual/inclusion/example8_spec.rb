# frozen_string_literal: true

RSpec.describe Usual::Inclusion::Example8 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "approved" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[event_name],
                     outputs: %i[event_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.event_name).to eq("approved")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inclusion::Example8] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end

        describe "because the value of `event_name` is not suitable for `internal`" do
          let(:event_name) { "created" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::Inclusion::Example8] Wrong value in `event_name`, must be one of " \
                "`[\"rejected\", \"approved\"]`"
              )
            )
          end
        end

        describe "because the value of `event_name` is not suitable for `output`" do
          let(:event_name) { "rejected" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::Inclusion::Example8] Wrong value in `event_name`, must be one of " \
                "`[\"approved\"]`"
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

    let(:event_name) { "approved" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[event_name],
                     outputs: %i[event_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.event_name).to eq("approved")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `event_name` is wrong" do
          let(:event_name) { "sent" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inclusion::Example8] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
              )
            )
          end
        end

        describe "because the value of `event_name` is not suitable for `internal`" do
          let(:event_name) { "created" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::Inclusion::Example8] Wrong value in `event_name`, must be one of " \
                "`[\"rejected\", \"approved\"]`"
              )
            )
          end
        end

        describe "because the value of `event_name` is not suitable for `output`" do
          let(:event_name) { "rejected" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::Inclusion::Example8] Wrong value in `event_name`, must be one of " \
                "`[\"approved\"]`"
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
