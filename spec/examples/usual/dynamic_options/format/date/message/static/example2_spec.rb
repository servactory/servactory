# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Date::Message::Static::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_on: started_on
      }
    end

    let(:started_on) { "2023-04-14" }

    include_examples "check class info",
                     inputs: %i[started_on],
                     internals: %i[started_on],
                     outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_on?).with(true) }
        it { expect(perform).to have_output(:started_on).with(Date.parse(started_on)) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).simulation(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        started_on: started_on
      }
    end

    let(:started_on) { "2023-04-14" }

    include_examples "check class info",
                     inputs: %i[started_on],
                     internals: %i[started_on],
                     outputs: %i[started_on]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:started_on?).with(true) }
        it { expect(perform).to have_output(:started_on).with(Date.parse(started_on)) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:started_on) { "2023-14-14" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:started_on).simulation(attributes).type(String).required }
    end
  end
end
