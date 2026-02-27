# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user_id:
      }
    end

    let(:user_id) { 47 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[greeting]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      before do
        allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
          .succeeds(full_name: "John Doe", user_email: "john@example.com")
      end

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:greeting, "Hello, John Doe!")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails with call!" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
            .fails(type: :user_not_found, message: "User with ID 47 not found")
        end

        it "raises expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:user_not_found)
              expect(exception.message).to eq("User with ID 47 not found")
              expect(exception.meta).to be_nil
            end
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

    let(:user_id) { 47 }

    it_behaves_like "check class info",
                    inputs: %i[user_id],
                    internals: %i[],
                    outputs: %i[greeting]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      before do
        allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
          .succeeds(full_name: "John Doe", user_email: "john@example.com")
      end

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:greeting, "Hello, John Doe!")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails with call!" do
        before do
          allow_service!(Usual::TestKit::Rspec::AllowServiceFluentApi::Example3Child)
            .fails(type: :user_not_found, message: "User with ID 47 not found")
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :user_not_found,
            message: "User with ID 47 not found",
            meta: nil
          )
        end
      end
    end
  end
end
