# frozen_string_literal: true

RSpec.describe Usual::Basic::Example13, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:,
        gender:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name gender],
                    internals: %i[first_name middle_name last_name gender],
                    outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:full_name).contains("JOHN FITZGERALD KENNEDY") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:gender).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:,
        gender:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name gender],
                    internals: %i[first_name middle_name last_name gender],
                    outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:full_name).contains("JOHN FITZGERALD KENNEDY") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:gender).valid_with(attributes).type(String).required }
    end
  end
end
