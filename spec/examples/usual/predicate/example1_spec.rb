# frozen_string_literal: true

RSpec.describe Usual::Predicate::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        enable:,
        text:,
        number:
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

        it { expect(perform).to have_output(:is_enabled).with(true) }
        it { expect(perform).to have_output(:is_really_enabled).with(true) }
        it { expect(perform).to have_output(:is_text_present).with(true) }
        it { expect(perform).to have_output(:is_prepared_text_present).with(true) }
        it { expect(perform).to have_output(:is_number_present).with(true) }
        it { expect(perform).to have_output(:is_prepared_number_present).with(true) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:enable).valid_with(attributes).types(TrueClass, FalseClass).required }
      it { expect { perform }.to have_input(:text).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:number).valid_with(attributes).type(Integer).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        enable:,
        text:,
        number:
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

        it { expect(perform).to have_output(:is_enabled).with(true) }
        it { expect(perform).to have_output(:is_really_enabled).with(true) }
        it { expect(perform).to have_output(:is_text_present).with(true) }
        it { expect(perform).to have_output(:is_prepared_text_present).with(true) }
        it { expect(perform).to have_output(:is_number_present).with(true) }
        it { expect(perform).to have_output(:is_prepared_number_present).with(true) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:enable).valid_with(attributes).types(TrueClass, FalseClass).required }
      it { expect { perform }.to have_input(:text).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:number).valid_with(attributes).type(Integer).required }
    end
  end
end
