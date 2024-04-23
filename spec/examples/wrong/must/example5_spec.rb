# frozen_string_literal: true

RSpec.describe Wrong::Must::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    include_examples "check class info",
                     inputs: %i[],
                     internals: %i[],
                     outputs: %i[invoice_numbers first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # rubocop:disable Layout/LineLength
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              /\[Wrong::Must::Example5\] Syntax error inside `be_6_characters` of `invoice_numbers` output attribute: undefined local variable or method `this_method_does_not_exist' for (.*)Wrong::Must::Example5/
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
                     internals: %i[],
                     outputs: %i[invoice_numbers first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # rubocop:disable Layout/LineLength
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              /\[Wrong::Must::Example5\] Syntax error inside `be_6_characters` of `invoice_numbers` output attribute: undefined local variable or method `this_method_does_not_exist' for (.*)Wrong::Must::Example5/
            )
          )
        end
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
