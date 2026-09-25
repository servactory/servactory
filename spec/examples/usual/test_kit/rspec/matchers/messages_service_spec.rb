# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::Matchers::MessagesService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        status: :active,
        kind: :primary,
        number: 2
      }
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:status)
              .type(Symbol).message("Status must be a Symbol")
              .inclusion(%i[active inactive]).message(/active or inactive\z/)
          )
        end

        it do
          expect { perform }.to(
            have_service_input(:kind)
              .type(Symbol).message(:default)
              .inclusion(%i[primary secondary]).message(:default)
          )
        end

        it do
          expect { perform }.to(
            have_input(:number)
              .type(Integer)
              .must(
                :be_small,
                be_even: "Number must be even",
                be_positive: "[Usual::TestKit::Rspec::Matchers::MessagesService] Input `number` must \"be_positive\""
              )
          )
        end

        it do
          expect { perform }.not_to(
            have_input(:number)
              .must(:be_positive, :be_small, be_even: "Number must be odd")
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:state)
              .type(Symbol).message("State must be a Symbol")
              .inclusion(%i[new done]).message("State must be new or done")
          )
        end

        it do
          expect { perform }.to(
            have_service_internal(:count)
              .type(Integer)
              .must(:be_positive).message("Internal attribute `count` must be positive")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `number` is not positive" do
        let(:attributes) { super().merge(number: -2) }

        it "fails with the message checked by the matcher" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[Usual::TestKit::Rspec::Matchers::MessagesService] Input `number` must \"be_positive\""
          )
        end
      end

      describe "because `number` is odd" do
        let(:attributes) { super().merge(number: 3) }

        it "fails with the message checked by the matcher" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Input, "Number must be even")
        end
      end
    end
  end
end
