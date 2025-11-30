# frozen_string_literal: true

RSpec.describe Wrong::Arguments::ReservedNames::Input::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) { { internal: "test" } }

    it_behaves_like "check class info",
                    inputs: %i[internal],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the input name is reserved" do
        it "raises an input reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Arguments::ReservedNames::Input::Example3] Input uses reserved name `internal`"
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) { { internal: "test" } }

    it_behaves_like "check class info",
                    inputs: %i[internal],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the input name is reserved" do
        it "raises an input reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Arguments::ReservedNames::Input::Example3] Input uses reserved name `internal`"
          )
        end
      end
    end
  end
end
