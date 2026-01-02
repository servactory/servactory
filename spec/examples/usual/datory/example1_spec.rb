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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:id, id)
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:id)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:id)
              .instance_of(String)
          )
        end
      end
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:id, id)
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:id)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:id)
              .instance_of(String)
          )
        end
      end
    end
  end
end
