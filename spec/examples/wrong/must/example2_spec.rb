# frozen_string_literal: true

RSpec.describe Wrong::Must::Example2 do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[invoice_numbers],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # rubocop:disable Layout/LineLength
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              /\[Wrong::Must::Example2\] Syntax error inside `be_6_characters` of `invoice_numbers` internal attribute: undefined local variable or method `this_method_does_not_exist' for (.*)Wrong::Must::Example2/
            )
          )
        end
        # rubocop:enable Layout/LineLength
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[invoice_numbers],
                     outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # rubocop:disable Layout/LineLength
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              /\[Wrong::Must::Example2\] Syntax error inside `be_6_characters` of `invoice_numbers` internal attribute: undefined local variable or method `this_method_does_not_exist' for (.*)Wrong::Must::Example2/
            )
          )
        end
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
