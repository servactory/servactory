# frozen_string_literal: true

RSpec.describe Usual::Predicate::Example1, type: :service do
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
      it { expect(perform).to have_service_input(:enable).types(TrueClass, FalseClass).required }
      it { expect(perform).to have_service_input(:text).type(String).required }
      it { expect(perform).to have_service_input(:number).type(Integer).required }
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
      it { expect(perform).to have_service_input(:enable).types(TrueClass, FalseClass).required }
      it { expect(perform).to have_service_input(:text).type(String).required }
      it { expect(perform).to have_service_input(:number).type(Integer).required }
    end
  end
end
