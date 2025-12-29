# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example13, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        priority:
      }
    end

    let(:priority) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[priority],
                    internals: %i[],
                    outputs: %i[priority]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:priority).contains(5) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `priority` is below range" do
          let(:priority) { 0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example13] Wrong value in `priority`, " \
                "must be one of `1..10`, " \
                "got `0`"
              )
            )
          end
        end

        describe "because the value of `priority` is above range" do
          let(:priority) { 15 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example13] Wrong value in `priority`, " \
                "must be one of `1..10`, " \
                "got `15`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:priority)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(1..10)
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        priority:
      }
    end

    let(:priority) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[priority],
                    internals: %i[],
                    outputs: %i[priority]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:priority).contains(5) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `priority` is below range" do
          let(:priority) { 0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example13] Wrong value in `priority`, " \
                "must be one of `1..10`, " \
                "got `0`"
              )
            )
          end
        end

        describe "because the value of `priority` is above range" do
          let(:priority) { 15 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example13] Wrong value in `priority`, " \
                "must be one of `1..10`, " \
                "got `15`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:priority)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion(1..10)
        )
      end
    end
  end
end
