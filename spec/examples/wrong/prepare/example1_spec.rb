# frozen_string_literal: true

RSpec.describe Wrong::Prepare::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name:
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Prepare::Example1] Conflict in `event_name` input options: `prepare_vs_inclusion`"
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
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example1] Conflict in `event_name` input options: `prepare_vs_inclusion`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:event_name) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example1] Conflict in `event_name` input options: `prepare_vs_inclusion`"
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
        event_name:
      }
    end

    let(:event_name) { "created" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Prepare::Example1] Conflict in `event_name` input options: `prepare_vs_inclusion`"
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
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example1] Conflict in `event_name` input options: `prepare_vs_inclusion`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:event_name) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::Prepare::Example1] Conflict in `event_name` input options: `prepare_vs_inclusion`"
              )
            )
          end
        end
      end
    end
  end
end
