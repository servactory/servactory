# frozen_string_literal: true

RSpec.describe Wrong::Arguments::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[inputs],
                    outputs: %i[result]

    describe "but the data required for work is invalid" do
      describe "because the internal name is reserved" do
        it "raises an internal reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::Arguments::Example10] Internal attribute uses reserved name `inputs`"
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[inputs],
                    outputs: %i[result]

    describe "but the data required for work is invalid" do
      describe "because the internal name is reserved" do
        it "raises an internal reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::Arguments::Example10] Internal attribute uses reserved name `inputs`"
          )
        end
      end
    end
  end
end 