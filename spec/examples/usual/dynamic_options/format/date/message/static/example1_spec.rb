# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Date::Message::Static::Example1, type: :service do
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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:started_on?).contains(true) }
        it { expect(perform).to have_output(:started_on).contains(Date.parse(started_on)) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(attributes).type(String).required }
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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:started_on?).contains(true) }
        it { expect(perform).to have_output(:started_on).contains(Date.parse(started_on)) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).valid_with(attributes).type(String).required }
    end
  end
end
