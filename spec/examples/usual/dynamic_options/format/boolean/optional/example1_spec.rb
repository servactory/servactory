# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Boolean::Optional::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        boolean:
      }
    end

    let(:boolean) { nil }

    it_behaves_like "check class info",
                    inputs: %i[boolean],
                    internals: %i[],
                    outputs: %i[boolean]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:boolean, nil)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `boolean`" do
        let(:boolean) { "off" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Boolean::Optional::Example1] " \
              "Input `boolean` does not match `boolean` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:boolean)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        boolean:
      }
    end

    let(:boolean) { nil }

    it_behaves_like "check class info",
                    inputs: %i[boolean],
                    internals: %i[],
                    outputs: %i[boolean]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:boolean, nil)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `boolean`" do
        let(:boolean) { "off" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Boolean::Optional::Example1] " \
              "Input `boolean` does not match `boolean` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:boolean)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end
      end
    end
  end
end
