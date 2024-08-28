# frozen_string_literal: true

RSpec.describe Usual::Basic::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[
                       full_name_1 full_name_2 full_name_3 full_name_4
                       full_name_5 full_name_6 full_name_7 full_name_8
                       full_name_9 full_name_10
                     ]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name_1).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_2).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_3).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_4).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_5).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_6).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_7).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_8).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_9).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_10).with("John Fitzgerald Kennedy") }

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it { expect(perform).to have_output(:full_name_1).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_2).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_3).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_4).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_5).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_6).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_7).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_8).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_9).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_10).with("John Kennedy") }
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[
                       full_name_1 full_name_2 full_name_3 full_name_4
                       full_name_5 full_name_6 full_name_7 full_name_8
                       full_name_9 full_name_10
                     ]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name_1).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_2).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_3).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_4).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_5).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_6).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_7).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_8).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_9).with("John Fitzgerald Kennedy") }
        it { expect(perform).to have_output(:full_name_10).with("John Fitzgerald Kennedy") }

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it { expect(perform).to have_output(:full_name_1).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_2).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_3).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_4).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_5).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_6).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_7).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_8).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_9).with("John Kennedy") }
          it { expect(perform).to have_output(:full_name_10).with("John Kennedy") }
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end
  end
end
