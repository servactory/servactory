# frozen_string_literal: true

RSpec.describe Wrong::Arguments::Example20, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[failure]

    describe "but the data required for work is invalid" do
      describe "because the output name is reserved" do
        it "raises an output reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::Arguments::Example20] Output attribute uses reserved name `failure`"
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[failure]

    describe "but the data required for work is invalid" do
      describe "because the output name is reserved" do
        it "raises an output reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Output,
            "[Wrong::Arguments::Example20] Output attribute uses reserved name `failure`"
          )
        end
      end
    end
  end
end 