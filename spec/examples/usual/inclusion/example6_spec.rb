# frozen_string_literal: true

RSpec.describe Usual::Inclusion::Example6, type: :service do
  let(:attributes) do
    {
      event_name: event_name
    }
  end

  let(:event_name) { "approved" }

  describe "validation" do
    describe "inputs" do
      it do
        expect { perform }.to(
          have_input(:event_name)
            .valid_with(attributes)
            .type(String)
            .required
            .inclusion(%w[created rejected approved])
        )
      end
    end

    describe "internals" do
      it do
        expect { perform }.to(
          have_internal(:event_name)
            .type(String)
            .inclusion(%w[rejected approved])
        )
      end
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:event_name).with("approved") }
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Inclusion::Example6] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
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
              "[Usual::Inclusion::Example6] Wrong value in `event_name`, must be one of " \
                "`[\"rejected\", \"approved\"]`"
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
              "[Usual::Inclusion::Example6] Wrong value in `event_name`, must be one of " \
                "`[\"approved\"]`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    describe "and the data required for work is also valid" do
      include_examples "success result class"

      it { expect(perform).to have_output(:event_name).with("approved") }
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `event_name` is wrong" do
        let(:event_name) { "sent" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Inclusion::Example6] Wrong value in `event_name`, must be one of " \
                "`[\"created\", \"rejected\", \"approved\"]`"
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
              "[Usual::Inclusion::Example6] Wrong value in `event_name`, must be one of " \
                "`[\"rejected\", \"approved\"]`"
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
              "[Usual::Inclusion::Example6] Wrong value in `event_name`, must be one of " \
                "`[\"approved\"]`"
            )
          )
        end
      end
    end
  end
end
