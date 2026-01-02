# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Date::Message::Lambda::Example1, type: :service do
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              started_on: Date.parse(started_on),
              started_on?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `date`" do
        let(:started_on) { "2023-14-14" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Value `2023-14-14` does not match the format of `date` in `started_on`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:started_on)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:started_on)
              .instance_of(Date)
          )
        end
      end
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              started_on: Date.parse(started_on),
              started_on?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `date`" do
        let(:started_on) { "2023-14-14" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Value `2023-14-14` does not match the format of `date` in `started_on`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:started_on)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:started_on)
              .instance_of(Date)
          )
        end
      end
    end
  end
end
