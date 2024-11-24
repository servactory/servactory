# frozen_string_literal: true

RSpec.describe Wrong::Prepare::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { "6" }

    include_examples "check class info",
                     inputs: %i[number],
                     internals: %i[],
                     outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              NoMethodError,
              "undefined method `preparation_enabled' for an instance of Servactory::Inputs::IncomingArguments"
              # TODO: Need to add a prepared translation of the error.
              # ApplicationService::Exceptions::Input,
              # "[Wrong::Prepare::Example3] Conflict in `event_name` input options: `prepare_vs_inclusion`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { "6" }

    include_examples "check class info",
                     inputs: %i[number],
                     internals: %i[],
                     outputs: %i[number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              NoMethodError,
              "undefined method `preparation_enabled' for an instance of Servactory::Inputs::IncomingArguments"
              # TODO: Need to add a prepared translation of the error.
              # ApplicationService::Exceptions::Input,
              # "[Wrong::Prepare::Example3] Conflict in `event_name` input options: `prepare_vs_inclusion`"
            )
          )
        end
      end
    end
  end
end
