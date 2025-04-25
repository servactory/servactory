# frozen_string_literal: true

RSpec.describe Usual::Datory::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(attributes) }

    let(:attributes) do
      Usual::Datory::Example1::Event.deserialize(id:)
    end

    let(:id) { SecureRandom.uuid }

    it_behaves_like "check class info",
                    inputs: %i[id],
                    internals: %i[],
                    outputs: %i[id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:id).contains(id) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:id).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(attributes) }

    let(:attributes) do
      Usual::Datory::Example1::Event.deserialize(id:)
    end

    let(:id) { SecureRandom.uuid }

    it_behaves_like "check class info",
                    inputs: %i[id],
                    internals: %i[],
                    outputs: %i[id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:id).contains(id) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:id).valid_with(attributes).type(String).required }
    end
  end
end
