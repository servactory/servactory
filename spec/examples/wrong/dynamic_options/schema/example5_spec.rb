# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example5, type: :service do
  it_behaves_like "check class info",
                  inputs: %i[],
                  internals: %i[payload],
                  outputs: %i[]

  describe ".call!" do
    subject(:perform) { described_class.call! }

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "Problem with the value in the schema"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "Problem with the value in the schema"
          )
        )
      end
    end
  end
end
