# frozen_string_literal: true

RSpec.describe Usual::Example52 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        enable: enable,
        text: text
      }
    end

    let(:enable) { true }
    let(:text) { "text" }

    include_examples "check class info",
                     inputs: %i[enable text],
                     internals: %i[prepared_text],
                     outputs: %i[is_enabled is_text_present is_prepared_text_present]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.is_enabled).to be(true)
          expect(result.is_text_present).to be(true)
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `enable`" do
        it_behaves_like "input required check", name: :enable
        it_behaves_like "input type check", name: :enable, expected_type: [TrueClass, FalseClass]
      end

      context "when `text`" do
        it_behaves_like "input required check", name: :text
        it_behaves_like "input type check", name: :text, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        enable: enable,
        text: text
      }
    end

    let(:enable) { true }
    let(:text) { "text" }

    include_examples "check class info",
                     inputs: %i[enable text],
                     internals: %i[prepared_text],
                     outputs: %i[is_enabled is_text_present is_prepared_text_present]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.is_enabled).to be(true)
          expect(result.is_text_present).to be(true)
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `enable`" do
        it_behaves_like "input required check", name: :enable
        it_behaves_like "input type check", name: :enable, expected_type: [TrueClass, FalseClass]
      end

      context "when `text`" do
        it_behaves_like "input required check", name: :text
        it_behaves_like "input type check", name: :text, expected_type: String
      end
    end
  end
end
