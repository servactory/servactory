# frozen_string_literal: true

RSpec.describe Usual::Basic::Example3, type: :service do
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
    let(:middle_name) { nil }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name).with("John <unknown> Kennedy") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).direct(attributes).type(String).required }

      it {
        expect do
          perform
        end.to have_input(:middle_name).direct(attributes).type(String).optional.default("<unknown>")
      }

      it { expect { perform }.to have_input(:last_name).direct(attributes).type(String).required }
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
    let(:middle_name) { nil }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name).with("John <unknown> Kennedy") }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).direct(attributes).type(String).required }

      it {
        expect do
          perform
        end.to have_input(:middle_name).direct(attributes).type(String).optional.default("<unknown>")
      }

      it { expect { perform }.to have_input(:last_name).direct(attributes).type(String).required }
    end
  end
end
