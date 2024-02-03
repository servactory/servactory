# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example10 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          result = perform

          expect { result.fake_value }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Errors::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("[Wrong::Basic::Example10] Undefined method `fake_value` for `nil`")
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          result = perform

          expect { result.fake_value }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Errors::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("[Wrong::Basic::Example10] Undefined method `fake_value` for `nil`")
            end
          )
        end
      end
    end
  end
end
