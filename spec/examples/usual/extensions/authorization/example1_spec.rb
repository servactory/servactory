# frozen_string_literal: true

RSpec.describe Usual::Extensions::Authorization::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id: user_id,
        current_user_id: current_user_id
      }
    end

    let(:user_id) { 123 }
    let(:current_user_id) { 123 }

    it_behaves_like "check class info",
                    inputs: %i[user_id current_user_id],
                    internals: %i[],
                    outputs: %i[message]

    context "when the input arguments are valid" do
      describe "and the user is authorized" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.message).to eq("Access granted for user 123")
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:user_id)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:current_user_id)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id: user_id,
        current_user_id: current_user_id
      }
    end

    let(:user_id) { 123 }
    let(:current_user_id) { 123 }

    it_behaves_like "check class info",
                    inputs: %i[user_id current_user_id],
                    internals: %i[],
                    outputs: %i[message]

    context "when the input arguments are valid" do
      describe "and the user is authorized" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.message).to eq("Access granted for user 123")
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:user_id)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:current_user_id)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end
end
