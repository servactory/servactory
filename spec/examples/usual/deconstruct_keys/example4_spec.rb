# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[full_name token nickname]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:token)
              .instance_of(NilClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(full_name: "John Doe", token: nil)
        )
      end

      describe "unassigned output" do
        it "is absent from to_h while nil-valued output is present" do
          expect(perform.to_h).to eq(full_name: "John Doe", token: nil)
        end

        it "is absent from deconstruct_keys(nil) while nil-valued output is present" do
          expect(perform.deconstruct_keys(nil)).to eq(
            success: true,
            failure: false,
            full_name: "John Doe",
            token: nil
          )
        end

        it "is absent from deconstruct_keys with requested keys" do
          expect(perform.deconstruct_keys(%i[nickname token])).to eq(token: nil)
        end

        it "does not match a pattern that requires it" do
          matched = case perform
                    in { nickname: }
                      nickname
                    else
                      :no_match
                    end

          expect(matched).to eq(:no_match)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[full_name token nickname]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:token)
              .instance_of(NilClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(full_name: "John Doe", token: nil)
        )
      end

      describe "unassigned output" do
        it "is absent from to_h while nil-valued output is present" do
          expect(perform.to_h).to eq(full_name: "John Doe", token: nil)
        end

        it "is absent from deconstruct_keys(nil) while nil-valued output is present" do
          expect(perform.deconstruct_keys(nil)).to eq(
            success: true,
            failure: false,
            full_name: "John Doe",
            token: nil
          )
        end

        it "is absent from deconstruct_keys with requested keys" do
          expect(perform.deconstruct_keys(%i[nickname token])).to eq(token: nil)
        end

        it "does not match a pattern that requires it" do
          matched = case perform
                    in { nickname: }
                      nickname
                    else
                      :no_match
                    end

          expect(matched).to eq(:no_match)
        end
      end
    end
  end
end
