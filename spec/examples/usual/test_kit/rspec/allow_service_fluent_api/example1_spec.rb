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
    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payment_status)
              .instance_of(Symbol)
          )
        end

        it do
          expect(perform).to(
            have_output(:payment_transaction_id)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      before do
        allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
          .succeeds(transaction_id: "txn_mocked", status: :completed)
      end

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payment_status, :completed)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payment_transaction_id, "txn_mocked")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
            .fails(type: :base, message: "Payment declined")
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

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payment_status)
              .instance_of(Symbol)
          )
        end

        it do
          expect(perform).to(
            have_output(:payment_transaction_id)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      before do
        allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
          .succeeds(transaction_id: "txn_mocked", status: :completed)
      end

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payment_status, :completed)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payment_transaction_id, "txn_mocked")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example1Child)
            .fails(type: :base, message: "Payment declined")
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
