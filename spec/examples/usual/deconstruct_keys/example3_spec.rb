# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[user_name token]

    describe "validations" do
      describe "outputs" do
        it { expect(perform).to(have_output(:user_name).instance_of(String)) }
        it { expect(perform).to(have_output(:token).instance_of(NilClass)) }
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(user_name: "John", token: nil)
        )
      end

      describe "to_h and deconstruct_keys consistency" do
        it "includes nil-valued output in to_h" do
          result = perform

          expect(result.to_h).to eq(user_name: "John", token: nil)
        end

        it "includes nil-valued output in deconstruct_keys(nil)", :aggregate_failures do
          result = perform
          keys = result.deconstruct_keys(nil)

          expect(keys).to include(:user_name, :token)
          expect(keys[:token]).to be_nil
        end

        it "returns consistent output keys between to_h and deconstruct_keys" do
          result = perform
          state_keys = %i[success failure error]

          dk_output_keys = result.deconstruct_keys(nil).keys - state_keys
          to_h_keys = result.to_h.keys

          expect(to_h_keys).to match_array(dk_output_keys)
        end
      end

      describe "pattern matching" do
        it "matches nil token via case/in", :aggregate_failures do
          result = perform

          matched = case result
                    in { success: true, user_name:, token: nil }
                      { name: user_name, token_present: false }
                    else
                      nil
                    end

          expect(matched).to eq(name: "John", token_present: false)
        end

        it "captures nil token in pattern variable", :aggregate_failures do
          result = perform

          matched = case result
                    in { success: true, token: }
                      token
                    else
                      :no_match
                    end

          expect(matched).to be_nil
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[user_name token]

    describe "validations" do
      describe "outputs" do
        it { expect(perform).to(have_output(:user_name).instance_of(String)) }
        it { expect(perform).to(have_output(:token).instance_of(NilClass)) }
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(user_name: "John", token: nil)
        )
      end

      describe "to_h and deconstruct_keys consistency" do
        it "includes nil-valued output in to_h" do
          result = perform

          expect(result.to_h).to eq(user_name: "John", token: nil)
        end

        it "returns consistent output keys between to_h and deconstruct_keys" do
          result = perform
          state_keys = %i[success failure error]

          dk_output_keys = result.deconstruct_keys(nil).keys - state_keys
          to_h_keys = result.to_h.keys

          expect(to_h_keys).to match_array(dk_output_keys)
        end
      end

      describe "pattern matching" do
        it "matches nil token via case/in", :aggregate_failures do
          result = perform

          matched = case result
                    in { success: true, user_name:, token: nil }
                      { name: user_name, token_present: false }
                    else
                      nil
                    end

          expect(matched).to eq(name: "John", token_present: false)
        end
      end
    end
  end
end
