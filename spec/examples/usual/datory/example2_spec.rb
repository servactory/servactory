# frozen_string_literal: true

RSpec.describe Usual::Datory::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(attributes) }

    let(:attributes) do
      Usual::Datory::Example1::Event.serialize(id:)
    end

    let(:id) { SecureRandom.uuid }

    it_behaves_like "check class info",
                    inputs: %i[id],
                    internals: %i[],
                    outputs: %i[id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:id, id)
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:id).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(attributes) }

    let(:attributes) do
      Usual::Datory::Example1::Event.serialize(id:)
    end

    let(:id) { SecureRandom.uuid }

    it_behaves_like "check class info",
                    inputs: %i[id],
                    internals: %i[],
                    outputs: %i[id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:id, id)
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:id).valid_with(attributes).type(String).required }
    end
  end
end
