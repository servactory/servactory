# frozen_string_literal: true

RSpec.describe Wrong::Example7 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name: event_name
      }
    end

    let(:event_name) { "created" }

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InputError,
              "[Wrong::Example7] Conflict in `event_name` input options: `required_vs_default`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `event_name`" do
        describe "is not passed" do
          let(:event_name) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Wrong::Example7] Conflict in `event_name` input options: `required_vs_default`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:event_name) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Wrong::Example7] Conflict in `event_name` input options: `required_vs_default`"
              )
            )
          end
        end
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
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InputError,
              "[Wrong::Example7] Conflict in `event_name` input options: `required_vs_default`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `event_name`" do
        describe "is not passed" do
          let(:event_name) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Wrong::Example7] Conflict in `event_name` input options: `required_vs_default`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:event_name) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputError,
                "[Wrong::Example7] Conflict in `event_name` input options: `required_vs_default`"
              )
            )
          end
        end
      end
    end
  end
end
