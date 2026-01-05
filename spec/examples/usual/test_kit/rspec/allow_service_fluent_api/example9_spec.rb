# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        order_id:
      }
    end

    let(:order_id) { "ORD-12345" }

    it_behaves_like "check class info",
                    inputs: %i[order_id],
                    internals: %i[],
                    outputs: %i[order_summary]
    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:order_summary)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "with valid outputs (automatic validation passes)" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
            .with(order_id: "ORD-12345")
            .succeeds(order_number: 1001, customer_name: "John Doe", total_amount: 99.99)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:order_summary, "Order #1001: John Doe - $99.99")
          )
        end
      end
    end

    describe "automatic output validation catches errors" do
      describe "raises error for unknown output" do
        it "raises ValidationError with output name" do
          expect do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .succeeds(unknown_output: "value")
          end.to raise_error(
            Servactory::TestKit::Rspec::Helpers::OutputValidator::ValidationError,
            /unknown_output/
          )
        end
      end

      describe "raises error for type mismatch" do
        it "raises ValidationError with type information" do
          expect do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .succeeds(order_number: "not_an_integer")
          end.to raise_error(
            Servactory::TestKit::Rspec::Helpers::OutputValidator::ValidationError,
            /order_number.*Integer.*String/m
          )
        end
      end
    end

    describe "automatic input validation catches errors" do
      describe "raises error for unknown input" do
        it "raises ValidationError with input name" do
          expect do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
              .with(unknown_input: "value")
              .succeeds(order_number: 1001, customer_name: "Test", total_amount: 50.0)
          end.to raise_error(
            Servactory::TestKit::Rspec::Helpers::InputValidator::ValidationError,
            /unknown_input/
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        order_id:
      }
    end

    let(:order_id) { "ORD-67890" }

    it_behaves_like "check class info",
                    inputs: %i[order_id],
                    internals: %i[],
                    outputs: %i[order_summary]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:order_summary)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "with valid outputs" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
            .succeeds(order_number: 3003, customer_name: "Test User", total_amount: 200.50)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:order_summary, "Order #3003: Test User - $200.5")
          )
        end
      end
    end

    describe "automatic validation catches errors in then_succeeds" do
      it "raises error for unknown output in sequential call" do
        expect do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example9Child)
            .succeeds(order_number: 1001, customer_name: "First", total_amount: 10.0)
            .then_succeeds(unknown_sequential_output: "invalid")
        end.to raise_error(
          Servactory::TestKit::Rspec::Helpers::OutputValidator::ValidationError,
          /unknown_sequential_output/
        )
      end
    end
  end
end
