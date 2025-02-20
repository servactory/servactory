# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        event_name:
      }
    end

    let(:event_name) { "approved" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[event_name],
                     outputs: %i[event_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:event_name)
              .valid_with(attributes)
              .type(String)
              .required
              .inclusion(%w[created rejected approved]) { be_a(Proc) }
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:event_name)
              .type(String)
              .inclusion(%w[rejected approved]) { be_a(Proc) }
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:event_name)
              .contains("approved")
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:event_name).contains("approved") }
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Incorrect `event_name` specified: `sent`"
            )
          )
        end
      end

      describe "because the value of `event_name` is not suitable for `internal`" do
        let(:event_name) { "created" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Incorrect `event_name` specified: `created`"
            )
          )
        end
      end

      describe "because the value of `event_name` is not suitable for `output`" do
        let(:event_name) { "rejected" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Incorrect `event_name` specified: `rejected`"
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
        event_name:
      }
    end

    let(:event_name) { "approved" }

    include_examples "check class info",
                     inputs: %i[event_name],
                     internals: %i[event_name],
                     outputs: %i[event_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:event_name)
              .valid_with(attributes)
              .type(String)
              .required
              .inclusion(%w[created rejected approved]) { be_a(Proc) }
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:event_name)
              .type(String)
              .inclusion(%w[rejected approved]) { be_a(Proc) }
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:event_name)
              .contains("approved")
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:event_name).contains("approved") }
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Incorrect `event_name` specified: `sent`"
            )
          )
        end
      end

      describe "because the value of `event_name` is not suitable for `internal`" do
        let(:event_name) { "created" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Incorrect `event_name` specified: `created`"
            )
          )
        end
      end

      describe "because the value of `event_name` is not suitable for `output`" do
        let(:event_name) { "rejected" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "Incorrect `event_name` specified: `rejected`"
            )
          )
        end
      end
    end
  end
end
