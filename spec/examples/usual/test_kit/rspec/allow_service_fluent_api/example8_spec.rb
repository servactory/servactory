# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example8, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[display_name contact_email account_status]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with output() singular method for each output" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
              .as_success
              .inputs(user_id: 42)
              .output(:user_name, "John Doe")
              .output(:user_email, "john@example.com")
              .output(:is_active, true)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:display_name).contains("John Doe") }
          it { expect(perform).to have_output(:contact_email).contains("john@example.com") }
          it { expect(perform).to have_output(:account_status).contains(:active) }
        end

        describe "mixing output() and outputs()" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
              .as_success
              .inputs(user_id: 42)
              .outputs(user_name: "Jane Smith", user_email: "jane@example.com")
              .output(:is_active, false)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:display_name).contains("Jane Smith") }
          it { expect(perform).to have_output(:contact_email).contains("jane@example.com") }
          it { expect(perform).to have_output(:account_status).contains(:inactive) }
        end

        describe "output() can override previous values" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
              .as_success
              .inputs(user_id: 42)
              .output(:user_name, "Initial Name")
              .output(:user_email, "initial@example.com")
              .output(:is_active, true)
              .output(:user_name, "Updated Name")
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:display_name).contains("Updated Name") }
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 99 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "with output() in different order" do
          before do
            allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
              .as_success
              .output(:is_active, true)
              .output(:user_email, "order@example.com")
              .output(:user_name, "Order Test")
              .inputs(user_id: 99)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:display_name).contains("Order Test") }
          it { expect(perform).to have_output(:contact_email).contains("order@example.com") }
          it { expect(perform).to have_output(:account_status).contains(:active) }
        end
      end
    end
  end
end
