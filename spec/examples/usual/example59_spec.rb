# frozen_string_literal: true

RSpec.describe Usual::Example59 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        gender: gender
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name gender],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John Fitzgerald Kennedy")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `first_name`" do
        it_behaves_like "input required check", name: :first_name
        it_behaves_like "input type check", name: :first_name, expected_type: String
      end

      context "when `middle_name`" do
        it_behaves_like "input required check", name: :middle_name
        it_behaves_like "input type check", name: :middle_name, expected_type: String
      end

      context "when `last_name`" do
        it_behaves_like "input required check", name: :last_name
        it_behaves_like "input type check", name: :last_name, expected_type: String
      end

      context "when `gender`" do
        it_behaves_like "input required check", name: :gender
        it_behaves_like "input type check", name: :gender, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        gender: gender
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name gender],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John Fitzgerald Kennedy")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `first_name`" do
        it_behaves_like "input required check", name: :first_name
        it_behaves_like "input type check", name: :first_name, expected_type: String
      end

      context "when `middle_name`" do
        it_behaves_like "input required check", name: :middle_name
        it_behaves_like "input type check", name: :middle_name, expected_type: String
      end

      context "when `last_name`" do
        it_behaves_like "input required check", name: :last_name
        it_behaves_like "input type check", name: :last_name, expected_type: String
      end

      context "when `gender`" do
        it_behaves_like "input required check", name: :gender
        it_behaves_like "input type check", name: :gender, expected_type: String
      end
    end
  end
end
