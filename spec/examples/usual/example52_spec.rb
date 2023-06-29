# frozen_string_literal: true

RSpec.describe Usual::Example52 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        enable: enable,
        text: text,
        number: number
      }
    end

    let(:enable) { true }
    let(:text) { "text" }
    let(:number) { 47 }

    include_examples "check class info",
                     inputs: %i[enable text number],
                     internals: %i[prepared_text prepared_number],
                     outputs: %i[
                       is_enabled is_really_enabled
                       is_text_present is_prepared_text_present
                       is_number_present is_prepared_number_present
                     ]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`", :aggregate_failures do
          result = perform

          expect(result.is_enabled).to be(true)
          expect(result.is_really_enabled).to be(true)
          expect(result.is_text_present).to be(true)
          expect(result.is_prepared_text_present).to be(true)
          expect(result.is_number_present).to be(true)
          expect(result.is_prepared_number_present).to be(true)
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

      context "when `number`" do
        it_behaves_like "input required check", name: :number
        it_behaves_like "input type check", name: :number, expected_type: Integer
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        enable: enable,
        text: text,
        number: number
      }
    end

    let(:enable) { true }
    let(:text) { "text" }
    let(:number) { 47 }

    include_examples "check class info",
                     inputs: %i[enable text number],
                     internals: %i[prepared_text prepared_number],
                     outputs: %i[
                       is_enabled is_really_enabled
                       is_text_present is_prepared_text_present
                       is_number_present is_prepared_number_present
                     ]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`", :aggregate_failures do
          result = perform

          expect(result.is_enabled).to be(true)
          expect(result.is_really_enabled).to be(true)
          expect(result.is_text_present).to be(true)
          expect(result.is_prepared_text_present).to be(true)
          expect(result.is_number_present).to be(true)
          expect(result.is_prepared_number_present).to be(true)
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

      context "when `number`" do
        it_behaves_like "input required check", name: :number
        it_behaves_like "input type check", name: :number, expected_type: Integer
      end
    end
  end
end
