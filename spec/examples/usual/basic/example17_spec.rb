# frozen_string_literal: true

RSpec.describe Usual::Basic::Example17, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name last_name middle_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John Fitzgerald Kennedy")
        end

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it "returns the expected value in `full_name`" do
            result = perform

            expect(result.full_name).to eq("John Kennedy")
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when the input arguments are invalid" do
        it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
        it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
        it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name last_name middle_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John Fitzgerald Kennedy")
        end

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it "returns the expected value in `full_name`" do
            result = perform

            expect(result.full_name).to eq("John Kennedy")
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when the input arguments are invalid" do
        it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
        it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
        it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
      end
    end
  end
end
