# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example8, type: :service do
  let(:attributes) do
    {
      payload:
    }
  end

  let(:payload) do
    nil
  end

  include_examples "check class info",
                   inputs: %i[payload],
                   internals: %i[payload],
                   outputs: %i[payload full_name]

  describe "validation" do
    describe "inputs" do
      it do # rubocop:disable RSpec/ExampleLength
        expect { perform }.to(
          have_input(:payload)
            .valid_with(attributes)
            .types(Hash)
            .schema(
              {
                request_id: { type: String, required: true },
                user: {
                  type: Hash,
                  required: true,
                  first_name: { type: String, required: true },
                  middle_name: { type: String, required: false },
                  last_name: { type: String, required: true },
                  passport: {
                    type: Hash,
                    required: true,
                    series: { type: String, required: true },
                    number: { type: String, required: true }
                  }
                }
              }
            )
            .optional
        )
      end
    end

    describe "internals" do
      it do # rubocop:disable RSpec/ExampleLength
        expect { perform }.to(
          have_internal(:payload)
            .types(NilClass, Hash)
            .schema(
              {
                request_id: { type: String, required: true },
                user: {
                  type: Hash,
                  required: true,
                  first_name: { type: String, required: true },
                  middle_name: { type: String, required: false },
                  last_name: { type: String, required: true },
                  passport: {
                    type: Hash,
                    required: true,
                    series: { type: String, required: true },
                    number: { type: String, required: true }
                  }
                }
              }
            )
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:payload).contains(nil) }

      it { expect(perform).to have_output(:full_name).contains(nil) }

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it { expect(perform).to have_output(:payload).contains(nil) }

        it { expect(perform).to have_output(:full_name).contains(nil) }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:payload).contains(nil) }

      it { expect(perform).to have_output(:full_name).contains(nil) }

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it { expect(perform).to have_output(:payload).contains(nil) }

        it { expect(perform).to have_output(:full_name).contains(nil) }
      end
    end
  end
end
