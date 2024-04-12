# frozen_string_literal: true

RSpec.describe Usual::Basic::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        gender: gender
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name gender],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_service_input(:first_name).type(String).required }
      it { expect { perform }.to have_service_input(:middle_name).type(String).required }
      it { expect { perform }.to have_service_input(:last_name).type(String).required }
      it { expect { perform }.to have_service_input(:gender).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        gender: gender
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name gender],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_service_input(:first_name).type(String).required }
      it { expect { perform }.to have_service_input(:middle_name).type(String).required }
      it { expect { perform }.to have_service_input(:last_name).type(String).required }
      it { expect { perform }.to have_service_input(:gender).type(String).required }
    end
  end
end
