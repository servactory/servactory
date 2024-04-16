# frozen_string_literal: true

RSpec.describe Usual::Basic::Example2, type: :service do
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

  describe "validation" do
    describe "inputs" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end

    describe "internals" do
      it { expect { perform }.to have_internal(:prepared_full_name).type(String) }
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it { expect(perform).to have_output(:full_name).with("John Kennedy") }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it { expect(perform).to have_output(:full_name).with("John Kennedy") }
      end
    end
  end
end
