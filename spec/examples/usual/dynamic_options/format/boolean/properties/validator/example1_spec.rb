# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Boolean::Properties::Validator::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        boolean:
      }
    end

    let(:boolean) { "yes" }

    it_behaves_like "check class info",
                    inputs: %i[boolean],
                    internals: %i[],
                    outputs: %i[boolean]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected value", :aggregate_failures do
        result = perform

        expect(result.boolean?).to be(true)
        expect(result.boolean).to eq("yes")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `boolean`" do
        let(:boolean) { "+" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Boolean::Properties::Validator::Example1] " \
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
              .required
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

    let(:boolean) { "yes" }

    it_behaves_like "check class info",
                    inputs: %i[boolean],
                    internals: %i[],
                    outputs: %i[boolean]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected value", :aggregate_failures do
        result = perform

        expect(result.boolean?).to be(true)
        expect(result.boolean).to eq("yes")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `boolean`" do
        let(:boolean) { "+" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Boolean::Properties::Validator::Example1] " \
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
              .required
          )
        end
      end
    end
  end
end
