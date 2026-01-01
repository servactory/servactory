# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsSuccess::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount:,
        currency:
      }
    end

    let(:amount) { 100 }
    let(:currency) { "USD" }

    it_behaves_like "check class info",
                    inputs: %i[amount currency],
                    internals: %i[],
                    outputs: %i[display_value]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with: parameter for argument matching" do
          before do
            allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example4Child,
                                     with: { amount: 100, currency: "USD" }) do
              { formatted_amount: "100 US Dollars" }
            end
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:display_value, "100 US Dollars")
            )
          end
        end

        describe "without with: parameter (matches any inputs)" do
          before do
            allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example4Child) do
              { formatted_amount: "Any Amount" }
            end
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:display_value, "Any Amount")
            )
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        amount:,
        currency:
      }
    end

    let(:amount) { 500 }
    let(:currency) { "EUR" }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with exact with: matching" do
          before do
            allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example4Child,
                                     with: { amount: 500, currency: "EUR" }) do
              { formatted_amount: "500 Euros" }
            end
          end

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:display_value, "500 Euros")
            )
          end
        end
      end
    end
  end
end
