# frozen_string_literal: true

RSpec.describe Usual::Extensions::StatusActive::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user:
      }
    end

    let(:user) { Usual::Extensions::StatusActive::Example1::User.new(active: true) }

    it_behaves_like "check class info",
                    inputs: %i[user],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:user)
              .valid_with(attributes)
              .type(Usual::Extensions::StatusActive::Example1::User)
              .required
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the user is not active" do
        let(:user) { Usual::Extensions::StatusActive::Example1::User.new(active: false) }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "User is not active"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user:
      }
    end

    let(:user) { Usual::Extensions::StatusActive::Example1::User.new(active: true) }

    it_behaves_like "check class info",
                    inputs: %i[user],
                    internals: %i[],
                    outputs: %i[]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the user is not active" do
        let(:user) { Usual::Extensions::StatusActive::Example1::User.new(active: false) }

        it "raises expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "User is not active"
            )
          )
        end
      end
    end
  end
end
