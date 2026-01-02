# frozen_string_literal: true

RSpec.describe Usual::Extensions::Authorization::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_role:
      }
    end

    let(:user_role) { "admin" }

    it_behaves_like "check class info",
                    inputs: %i[user_role],
                    internals: %i[],
                    outputs: %i[message]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:user_role)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          result = perform
          expect(result.message).to be_a(String)
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with message" do
        expect(perform).to be_success_service
        expect(perform.message).to eq("Access granted for admin")
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_role:
      }
    end

    let(:user_role) { "admin" }

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with message" do
        expect(perform).to be_success_service
        expect(perform.message).to eq("Access granted for admin")
      end
    end
  end
end
