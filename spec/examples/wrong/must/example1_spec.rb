# frozen_string_literal: true

RSpec.describe Wrong::Must::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_numbers:
      }
    end

    let(:invoice_numbers) do
      %w[
        7650AE
        B4EA1B
        A7BC86
        BD2D6B
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[invoice_numbers],
                    internals: %i[],
                    outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # rubocop:disable Layout/LineLength
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                "[Wrong::Must::Example1] Syntax error inside `be_6_characters` of `invoice_numbers` input: undefined local variable or method 'this_method_does_not_exist' for class Wrong::Must::Example1"
              else
                /\[Wrong::Must::Example1\] Syntax error inside `be_6_characters` of `invoice_numbers` input: undefined local variable or method `this_method_does_not_exist' for (.*)Wrong::Must::Example1(.*)/
              end
            )
          )
        end
        # rubocop:enable Layout/LineLength
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_numbers:
      }
    end

    let(:invoice_numbers) do
      %w[
        7650AE
        B4EA1B
        A7BC86
        BD2D6B
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[invoice_numbers],
                    internals: %i[],
                    outputs: %i[first_invoice_number]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        # rubocop:disable Layout/LineLength
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                "[Wrong::Must::Example1] Syntax error inside `be_6_characters` of `invoice_numbers` input: undefined local variable or method 'this_method_does_not_exist' for class Wrong::Must::Example1"
              else
                /\[Wrong::Must::Example1\] Syntax error inside `be_6_characters` of `invoice_numbers` input: undefined local variable or method `this_method_does_not_exist' for (.*)Wrong::Must::Example1(.*)/
              end
            )
          )
        end
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
