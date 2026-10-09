# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[success error full_name]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:success)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(success: "Saved", full_name: "John Doe")
        )
      end

      describe "outputs named after state keys" do
        it "are present in to_h" do
          expect(perform.to_h).to eq(success: "Saved", error: "None", full_name: "John Doe")
        end

        it "do not override state keys in deconstruct_keys(nil)" do
          expect(perform.deconstruct_keys(nil)).to eq(
            success: true,
            failure: false,
            full_name: "John Doe"
          )
        end

        it "do not override state keys in deconstruct_keys with requested keys" do
          expect(perform.deconstruct_keys(%i[success error full_name])).to eq(
            success: true,
            full_name: "John Doe"
          )
        end

        it "match the success state in a pattern" do
          matched = case perform
                    in { success: true, full_name: }
                      full_name
                    else
                      :no_match
                    end

          expect(matched).to eq("John Doe")
        end

        it "do not match a pattern that requires :error" do
          matched = case perform
                    in { error: }
                      error
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
                    outputs: %i[success error full_name]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:success)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(success: "Saved", full_name: "John Doe")
        )
      end

      describe "outputs named after state keys" do
        it "are present in to_h" do
          expect(perform.to_h).to eq(success: "Saved", error: "None", full_name: "John Doe")
        end

        it "do not override state keys in deconstruct_keys(nil)" do
          expect(perform.deconstruct_keys(nil)).to eq(
            success: true,
            failure: false,
            full_name: "John Doe"
          )
        end

        it "do not override state keys in deconstruct_keys with requested keys" do
          expect(perform.deconstruct_keys(%i[success error full_name])).to eq(
            success: true,
            full_name: "John Doe"
          )
        end

        it "match the success state in a pattern" do
          matched = case perform
                    in { success: true, full_name: }
                      full_name
                    else
                      :no_match
                    end

          expect(matched).to eq("John Doe")
        end

        it "do not match a pattern that requires :error" do
          matched = case perform
                    in { error: }
                      error
                    else
                      :no_match
                    end

          expect(matched).to eq(:no_match)
        end
      end
    end
  end
end
