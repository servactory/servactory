# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Date::Optional::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_on:
      }
    end

    let(:started_on) { nil }

    it_behaves_like "check class info",
                    inputs: %i[started_on],
                    internals: %i[],
                    outputs: %i[started_on]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:started_on?).contains(false)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:started_on, nil)
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
              "[Usual::DynamicOptions::Format::Date::Optional::Example1] " \
              "Input `started_on` does not match `date` format"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(attributes).type(String).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_on:
      }
    end

    let(:started_on) { nil }

    it_behaves_like "check class info",
                    inputs: %i[started_on],
                    internals: %i[],
                    outputs: %i[started_on]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:started_on?).contains(false)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:started_on, nil)
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
              "[Usual::DynamicOptions::Format::Date::Optional::Example1] " \
              "Input `started_on` does not match `date` format"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(attributes).type(String).optional }
    end
  end
end
