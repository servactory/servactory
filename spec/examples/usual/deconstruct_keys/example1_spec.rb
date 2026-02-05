# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[user_name user_age]

    describe "validations" do
      describe "outputs" do
        it { expect(perform).to(have_output(:user_name).instance_of(String)) }
        it { expect(perform).to(have_output(:user_age).instance_of(Integer)) }
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(user_name: "John", user_age: 25)
        )
      end

      describe "pattern matching" do
        it "returns all keys via deconstruct_keys(nil)", :aggregate_failures do
          result = perform
          keys = result.deconstruct_keys(nil)

          expect(keys).to include(:success, :failure, :user_name, :user_age)
          expect(keys[:success]).to be(true)
          expect(keys[:failure]).to be(false)
          expect(keys).not_to have_key(:error)
        end

        it "returns only requested keys via deconstruct_keys([:success, :user_name])" do
          result = perform
          keys = result.deconstruct_keys(%i[success user_name])

          expect(keys).to eq(success: true, user_name: "John")
        end

        it "supports case/in pattern matching", :aggregate_failures do
          result = perform

          matched = case result
                    in { success: true, user_name:, user_age: }
                      { name: user_name, age: user_age }
                    else
                      nil
                    end

          expect(matched).to eq(name: "John", age: 25)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[user_name user_age]

    describe "validations" do
      describe "outputs" do
        it { expect(perform).to(have_output(:user_name).instance_of(String)) }
        it { expect(perform).to(have_output(:user_age).instance_of(Integer)) }
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(user_name: "John", user_age: 25)
        )
      end

      describe "pattern matching" do
        it "returns all keys via deconstruct_keys(nil)", :aggregate_failures do
          result = perform
          keys = result.deconstruct_keys(nil)

          expect(keys).to include(:success, :failure, :user_name, :user_age)
          expect(keys[:success]).to be(true)
          expect(keys[:failure]).to be(false)
          expect(keys).not_to have_key(:error)
        end

        it "supports case/in pattern matching", :aggregate_failures do
          result = perform

          matched = case result
                    in { success: true, user_name:, user_age: }
                      { name: user_name, age: user_age }
                    else
                      nil
                    end

          expect(matched).to eq(name: "John", age: 25)
        end
      end
    end
  end
end
