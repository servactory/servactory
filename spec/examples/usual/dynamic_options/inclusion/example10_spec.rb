# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: %i[number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 3)
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `number` is wrong" do
          let(:number) { 0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example10] Wrong value in `number`, " \
                "must be one of `[1, 2, 3]`, " \
                "got `0`"
              )
            )
          end
        end

        describe "because the value of `number` is not suitable for `internal`" do
          let(:number) { 1 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Inclusion::Example10] Wrong value in `number`, " \
                "must be one of `[2, 3]`, " \
                "got `1`"
              )
            )
          end
        end

        describe "because the value of `number` is not suitable for `output`" do
          let(:number) { 2 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::Inclusion::Example10] Wrong value in `number`, " \
                "must be one of `[3]`, " \
                "got `2`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion([1, 2, 3])
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: %i[number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 3)
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `number` is wrong" do
          let(:number) { 0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Inclusion::Example10] Wrong value in `number`, " \
                "must be one of `[1, 2, 3]`, " \
                "got `0`"
              )
            )
          end
        end

        describe "because the value of `number` is not suitable for `internal`" do
          let(:number) { 1 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Inclusion::Example10] Wrong value in `number`, " \
                "must be one of `[2, 3]`, " \
                "got `1`"
              )
            )
          end
        end

        describe "because the value of `number` is not suitable for `output`" do
          let(:number) { 2 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::Inclusion::Example10] Wrong value in `number`, " \
                "must be one of `[3]`, " \
                "got `2`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .type(Integer)
            .required
            .inclusion([1, 2, 3])
        )
      end
    end
  end
end
