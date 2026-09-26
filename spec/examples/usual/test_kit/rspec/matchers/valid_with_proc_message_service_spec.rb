# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::Matchers::ValidWithProcMessageService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        status: :active,
        handler: described_class::Handler,
        state: :active,
        worker: described_class::Handler
      }
    end

    let(:mismatch_message) do
      "Expected #{described_class.name} to have a service input attribute named %<name>s, " \
        "which should work as expected on the specified attributes based on its options"
    end

    it_behaves_like "check class info",
                    inputs: %i[status handler state worker],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        context "when the Proc message of `inclusion` matches the actual error" do
          it do
            expect { perform }.to(
              have_input(:status)
                .valid_with(attributes)
                .type(Symbol)
                .required
                .inclusion(%i[active inactive])
            )
          end
        end

        context "when the Proc message of `target` matches the actual error" do
          it do
            expect { perform }.to(
              have_input(:handler)
                .valid_with(attributes)
                .type(Class)
                .required
                .target([described_class::Handler])
            )
          end
        end

        context "when the Proc message of `inclusion` differs from the actual error" do
          it "fails", :aggregate_failures do
            matcher = have_input(:state).valid_with(attributes).type(Symbol).required

            expect(matcher.matches?(nil)).to be(false)
            expect(matcher.failure_message).to eq(format(mismatch_message, name: :state))
          end
        end

        context "when the Proc message of `target` differs from the actual error" do
          it "fails", :aggregate_failures do
            matcher = have_input(:worker).valid_with(attributes).type(Class).required

            expect(matcher.matches?(nil)).to be(false)
            expect(matcher.failure_message).to eq(format(mismatch_message, name: :worker))
          end
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"
    end

    describe "but the data required for work is invalid" do
      describe "because `status` is outside the inclusion" do
        before { attributes[:status] = :unknown }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[ValidWithProcMessageService] `status`: [:unknown, :be_inclusion, nil, :inclusion, [:active, :inactive]]"
          )
        end
      end

      describe "because `handler` is outside the target" do
        before { attributes[:handler] = String }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[ValidWithProcMessageService] `handler`: [String, :be_target, nil, :target, " \
            "[Usual::TestKit::Rspec::Matchers::ValidWithProcMessageService::Handler]]"
          )
        end
      end

      describe "because `state` breaks a rule checked before the inclusion" do
        before { attributes[:state] = :unknown }

        it "returns the message of that rule" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Input, "Input `state` is unknown")
        end
      end

      describe "because `worker` breaks a rule checked before the target" do
        before { attributes[:worker] = String }

        it "returns the message of that rule" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Input, "Input `worker` is unknown")
        end
      end
    end
  end
end
