# frozen_string_literal: true

RSpec.describe Usual::Example3 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name last_name middle_name],
                     internals: %i[prepared_full_name],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John Fitzgerald Kennedy")
        end

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it "returns the expected value in `full_name`" do
            result = perform

            expect(result.full_name).to eq("John Kennedy")
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `first_name`" do
        it_behaves_like "input required check", name: :first_name
        it_behaves_like "input type check", name: :first_name, expected_type: String
      end

      context "when `middle_name`" do
        it_behaves_like "input type check", name: :middle_name, expected_type: String
      end

      context "when `last_name`" do
        it_behaves_like "input required check", name: :last_name
        it_behaves_like "input type check", name: :last_name, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name last_name middle_name],
                     internals: %i[prepared_full_name],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `full_name`" do
          result = perform

          expect(result.full_name).to eq("John Fitzgerald Kennedy")
        end

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it "returns the expected value in `full_name`" do
            result = perform

            expect(result.full_name).to eq("John Kennedy")
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `first_name`" do
        it_behaves_like "input required check", name: :first_name
        it_behaves_like "input type check", name: :first_name, expected_type: String
      end

      context "when `middle_name`" do
        it_behaves_like "input type check", name: :middle_name, expected_type: String
      end

      context "when `last_name`" do
        it_behaves_like "input required check", name: :last_name
        it_behaves_like "input type check", name: :last_name, expected_type: String
      end
    end
  end
end
