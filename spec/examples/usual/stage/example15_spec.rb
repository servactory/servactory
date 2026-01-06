# frozen_string_literal: true

RSpec.describe Usual::Stage::Example15, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "rollback is called without wrapper and sets number to 9" do
        expect(perform).to(
          be_success_service
            .with_output(:number, 9)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "rollback is called without wrapper and sets number to 9" do
        expect(perform).to(
          be_success_service
            .with_output(:number, 9)
        )
      end
    end
  end
end
