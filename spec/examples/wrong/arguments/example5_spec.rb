# frozen_string_literal: true

RSpec.describe Wrong::Arguments::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) { { output: "test" } }

    it_behaves_like "check class info",
                    inputs: %i[output],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the input name is reserved" do
        it "raises an input reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Arguments::Example5] Input uses reserved name `output`"
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) { { output: "test" } }

    it_behaves_like "check class info",
                    inputs: %i[output],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the input name is reserved" do
        it "raises an input reserved name exception" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::Arguments::Example5] Input uses reserved name `output`"
          )
        end
      end
    end
  end
end
