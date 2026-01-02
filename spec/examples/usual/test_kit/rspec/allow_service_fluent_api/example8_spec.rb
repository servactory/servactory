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
    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:display_name)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:contact_email)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:account_status)
              .instance_of(Symbol)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "with succeeds() providing all outputs at once" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
            .with(user_id: 42)
            .succeeds(user_name: "John Doe", user_email: "john@example.com", is_active: true)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:display_name, "John Doe")
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:contact_email, "john@example.com")
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:account_status, :active)
          )
        end
      end

      describe "with inputs before succeeds" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
            .with(user_id: 42)
            .succeeds(user_name: "Jane Smith", user_email: "jane@example.com", is_active: false)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:display_name, "Jane Smith")
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:contact_email, "jane@example.com")
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:account_status, :inactive)
          )
        end
      end

      describe "with succeeds before inputs" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
            .succeeds(user_name: "Updated Name", user_email: "updated@example.com", is_active: true)
            .with(user_id: 42)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:display_name, "Updated Name")
          )
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

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[display_name contact_email account_status]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:display_name)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:contact_email)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:account_status)
              .instance_of(Symbol)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "with inputs after succeeds" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example8Child)
            .succeeds(is_active: true, user_email: "order@example.com", user_name: "Order Test")
            .with(user_id: 99)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:display_name, "Order Test")
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:contact_email, "order@example.com")
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:account_status, :active)
          )
        end
      end
    end
  end
end
