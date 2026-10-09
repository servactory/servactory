# frozen_string_literal: true

RSpec.describe Usual::DeconstructKeys::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[full_name age]

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
            have_output(:age)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(full_name: "John Doe", age: 25)
        )
      end

      describe "pattern matching" do
        it "returns all keys via deconstruct_keys(nil)", :aggregate_failures do
          keys = perform.deconstruct_keys(nil)

          expect(keys).to include(:success, :failure, :full_name, :age)
          expect(keys[:success]).to be(true)
          expect(keys[:failure]).to be(false)
          expect(keys).not_to have_key(:error)
        end

        it "returns only requested keys via deconstruct_keys([:success, :full_name])" do
          keys = perform.deconstruct_keys(%i[success full_name])

          expect(keys).to eq(success: true, full_name: "John Doe")
        end

        it "supports case/in pattern matching", :aggregate_failures do
          matched = case perform
                    in { success: true, full_name:, age: }
                      { name: full_name, age: }
                    else
                      nil
                    end

          expect(matched).to eq(name: "John Doe", age: 25)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[full_name age]

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
            have_output(:age)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(full_name: "John Doe", age: 25)
        )
      end

      describe "pattern matching" do
        it "returns all keys via deconstruct_keys(nil)", :aggregate_failures do
          keys = perform.deconstruct_keys(nil)

          expect(keys).to include(:success, :failure, :full_name, :age)
          expect(keys[:success]).to be(true)
          expect(keys[:failure]).to be(false)
          expect(keys).not_to have_key(:error)
        end

        it "supports case/in pattern matching", :aggregate_failures do
          matched = case perform
                    in { success: true, full_name:, age: }
                      { name: full_name, age: }
                    else
                      nil
                    end

          expect(matched).to eq(name: "John Doe", age: 25)
        end
      end
    end
  end
end
