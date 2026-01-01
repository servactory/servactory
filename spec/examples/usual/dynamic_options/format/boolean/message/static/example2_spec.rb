# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Boolean::Message::Static::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        boolean:
      }
    end

    let(:boolean) { "true" }

    it_behaves_like "check class info",
                    inputs: %i[boolean],
                    internals: %i[boolean],
                    outputs: %i[boolean]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:boolean?).contains(true) }
        it { expect(perform).to have_output(:boolean).contains("true") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `boolean`" do
          let(:boolean) { "off" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid boolean format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:boolean).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        boolean:
      }
    end

    let(:boolean) { "true" }

    it_behaves_like "check class info",
                    inputs: %i[boolean],
                    internals: %i[boolean],
                    outputs: %i[boolean]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:boolean?).contains(true) }
        it { expect(perform).to have_output(:boolean).contains("true") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `boolean`" do
          let(:boolean) { "off" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid boolean format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:boolean).valid_with(attributes).type(String).required }
    end
  end
end
