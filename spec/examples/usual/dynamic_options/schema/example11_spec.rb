# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example11, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[payload issued_on]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end

        it do
          expect(perform).to(
            have_output(:issued_on)
              .instance_of(DateTime)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:payload)
            .contains(
              {
                issued_on: DateTime.new(2023, 1, 1)
              }
            )
        )
      end

      it do
        expect(perform).to(
          have_output(:issued_on)
            .contains(DateTime.new(2023, 1, 1))
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[payload issued_on]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end

        it do
          expect(perform).to(
            have_output(:issued_on)
              .instance_of(DateTime)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:payload)
            .contains(
              {
                issued_on: DateTime.new(2023, 1, 1)
              }
            )
        )
      end

      it do
        expect(perform).to(
          have_output(:issued_on)
            .contains(DateTime.new(2023, 1, 1))
        )
      end
    end
  end
end
