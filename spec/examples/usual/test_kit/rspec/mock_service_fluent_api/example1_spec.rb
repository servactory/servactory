# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::MockServiceFluentApi::Example1, type: :service do
  describe ".call" do
    subject(:perform) { described_class.call(amount: 100) }

    context "with fluent API mock_service.as_success" do
      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example1Child)
          .as_success
          .with_outputs(transaction_id: "txn_mocked", status: :pending)
      end

      it "returns success" do
        expect(perform).to be_success_service
      end

      it "returns mocked outputs from child service" do
        result = perform.child_result

        expect(result.transaction_id).to eq("txn_mocked")
        expect(result.status).to eq(:pending)
      end
    end

    context "with fluent API mock_service.as_failure" do
      let(:error) do
        Servactory::Exceptions::Failure.new(
          type: :base,
          message: "Payment failed"
        )
      end

      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example1Child)
          .as_failure
          .with_exception(error)
      end

      it "returns failure" do
        expect(perform).to be_failure_service
      end
    end

    context "with fluent API when_called_with argument matcher" do
      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example1Child)
          .as_success
          .with_outputs(transaction_id: "txn_100", status: :completed)
          .when_called_with(amount: 100)
      end

      it "returns success when called with matching arguments" do
        expect(perform).to be_success_service
        expect(perform.child_result.transaction_id).to eq("txn_100")
      end
    end

    context "with fluent API using including() matcher" do
      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example1Child)
          .as_success
          .with_outputs(transaction_id: "txn_partial", status: :partial)
          .when_called_with(including(amount: 100))
      end

      it "returns success when partial arguments match" do
        expect(perform).to be_success_service
        expect(perform.child_result.transaction_id).to eq("txn_partial")
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(amount: 100) }

    context "with fluent API using_call!" do
      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example1Child)
          .as_success
          .with_outputs(transaction_id: "txn_bang", status: :done)
          .using_call!
      end

      it "returns success when using call!" do
        result = perform.child_result

        expect(result.transaction_id).to eq("txn_bang")
        expect(result.status).to eq(:done)
      end
    end

    context "with fluent API as_failure with exception using_call!" do
      let(:error) do
        Servactory::Exceptions::Failure.new(
          type: :payment_declined,
          message: "Payment was declined"
        )
      end

      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example1Child)
          .as_failure
          .with_exception(error)
          .using_call!
      end

      it "raises exception when using call! and failure" do
        expect { perform }.to raise_error(Servactory::Exceptions::Failure)
      end
    end
  end
end
