# frozen_string_literal: true

RSpec.describe Wrong::Arguments::Example17, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) { { fail: "something" } }

    it_behaves_like "check class info",
                    inputs: %i[fail],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the input name is reserved" do
        it "raises an input reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Arguments::Example17] Input uses reserved name `fail`"
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) { { fail: "something" } }

    it_behaves_like "check class info",
                    inputs: %i[fail],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the input name is reserved" do
        it "raises an input reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Arguments::Example17] Input uses reserved name `fail`"
          )
        end
      end
    end
  end
end
