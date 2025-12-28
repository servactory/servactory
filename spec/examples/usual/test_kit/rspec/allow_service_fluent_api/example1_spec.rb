# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[payment_status payment_transaction_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
            .as_success
            .outputs(transaction_id: "txn_mocked", status: :completed)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:payment_status).contains(:completed) }
        it { expect(perform).to have_output(:payment_transaction_id).contains("txn_mocked") }
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :base,
              message: "Payment declined"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
              .as_failure
              .with_exception(error)
          end

          it "raises expected exception", :aggregate_failures do
            expect { perform }.to raise_error(ApplicationService::Exceptions::Failure) do |exception|
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Payment declined")
              expect(exception.meta).to be_nil
            end
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
            .as_success
            .outputs(transaction_id: "txn_mocked", status: :completed)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:payment_status).contains(:completed) }
        it { expect(perform).to have_output(:payment_transaction_id).contains("txn_mocked") }
      end

      describe "but the data required for work is invalid" do
        describe "because child service fails" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :base,
              message: "Payment declined"
            )
          end

          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
              .as_failure
              .with_exception(error)
          end

          it "returns the expected value in `error`", :aggregate_failures do
            expect(perform.error).to be_a(ApplicationService::Exceptions::Failure)
            expect(perform.error).to an_object_having_attributes(
              type: :base,
              message: "Payment declined"
            )
          end
        end
      end
    end
  end
end
