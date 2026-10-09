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

    it_behaves_like "check class info",
                    inputs: %i[event_name],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:event_name)
              .valid_with(attributes)
              .type(String)
              .required
              .inclusion(%w[created rejected approved])
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the service has nothing to perform" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to(
                eq("[Wrong::Prepare::Example1] Nothing to perform. Use `make` or create a `call` method.")
              )
              expect(exception.meta).to be_nil
            end
          )
        end
      end

      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Prepare::Example1] Wrong value in `event_name`, " \
              "must be one of `[\"created\", \"rejected\", \"approved\"]`, " \
              "got `\"sent\"`"
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
        event_name:
      }
    end

    let(:event_name) { "created" }

    it_behaves_like "check class info",
                    inputs: %i[event_name],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:event_name)
              .valid_with(attributes)
              .type(String)
              .required
              .inclusion(%w[created rejected approved])
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the service has nothing to perform" do
        it_behaves_like "failure result class"

        it do
          expect(perform).to(
            be_failure_service
              .type(:base)
              .message("[Wrong::Prepare::Example1] Nothing to perform. Use `make` or create a `call` method.")
              .meta(nil)
          )
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "[Wrong::Prepare::Example1] Nothing to perform. Use `make` or create a `call` method.",
            meta: nil
          )
        end
      end

      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Prepare::Example1] Wrong value in `event_name`, " \
              "must be one of `[\"created\", \"rejected\", \"approved\"]`, " \
              "got `\"sent\"`"
            )
          )
        end
      end
    end
  end
end
