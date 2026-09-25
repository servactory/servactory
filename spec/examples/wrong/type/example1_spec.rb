# frozen_string_literal: true

RSpec.describe Wrong::Type::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) { {} }

    it_behaves_like "check class info",
                    inputs: %i[limit],
                    internals: %i[],
                    outputs: %i[limit]

    describe "and the data required for work is also valid" do
      let(:attributes) { { limit: 5 } }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:limit, 5)
        )
      end
    end

    describe "but the default value does not match the type" do
      it "returns the custom message" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Input `limit` must be an Integer, got `\"10\"` (String)"
          )
        )
      end
    end

    describe "but the passed value does not match the type" do
      let(:attributes) { { limit: 5.0 } }

      it "returns the custom message" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Input `limit` must be an Integer, got `5.0` (Float)"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) { {} }

    it_behaves_like "check class info",
                    inputs: %i[limit],
                    internals: %i[],
                    outputs: %i[limit]

    describe "and the data required for work is also valid" do
      let(:attributes) { { limit: 5 } }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:limit, 5)
        )
      end
    end

    describe "but the default value does not match the type" do
      it "returns the custom message" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Input `limit` must be an Integer, got `\"10\"` (String)"
          )
        )
      end
    end

    describe "but the passed value does not match the type" do
      let(:attributes) { { limit: 5.0 } }

      it "returns the custom message" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Input `limit` must be an Integer, got `5.0` (Float)"
          )
        )
      end
    end
  end
end
