# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::MultipleOf::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 30.0 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: [:number]

    describe "and the number required for work is also valid" do
      # NOTE: 30.0 is divisible by 2.0, 3.0, and 5.0

      context "when `number` is `30.0`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:number?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 30.0)
          )
        end
      end

      context "when `number` is `60.0`" do
        let(:number) { 60.0 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:number?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 60.0)
          )
        end
      end
    end

    describe "but the number required for work is invalid" do
      describe "for `input` attribute" do
        context "when value is not multiple of 2.0" do
          let(:number) { 5.0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::MultipleOf::Example4] " \
                "Input `number` has the value `5.0`, which is not a multiple of `2.0`"
              )
            )
          end
        end
      end

      describe "for `internal` attribute" do
        context "when value is multiple of 2.0 but not of 3.0" do
          let(:number) { 2.0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::MultipleOf::Example4] " \
                "Internal attribute `number` has the value `2.0`, which is not a multiple of `3.0`"
              )
            )
          end
        end
      end

      describe "for `output` attribute" do
        context "when value is multiple of 2.0 and 3.0 but not of 5.0" do
          let(:number) { 6.0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::MultipleOf::Example4] " \
                "Output attribute `number` has the value `6.0`, which is not a multiple of `5.0`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number).valid_with(attributes).type(Float).required
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

    let(:number) { 30.0 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: [:number]

    describe "and the number required for work is also valid" do
      context "when `number` is `30.0`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:number?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 30.0)
          )
        end
      end

      context "when `number` is `60.0`" do
        let(:number) { 60.0 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:number?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 60.0)
          )
        end
      end
    end

    describe "but the number required for work is invalid" do
      describe "for `input` attribute" do
        context "when value is not multiple of 2.0" do
          let(:number) { 5.0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::MultipleOf::Example4] " \
                "Input `number` has the value `5.0`, which is not a multiple of `2.0`"
              )
            )
          end
        end
      end

      describe "for `internal` attribute" do
        context "when value is multiple of 2.0 but not of 3.0" do
          let(:number) { 2.0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::MultipleOf::Example4] " \
                "Internal attribute `number` has the value `2.0`, which is not a multiple of `3.0`"
              )
            )
          end
        end
      end

      describe "for `output` attribute" do
        context "when value is multiple of 2.0 and 3.0 but not of 5.0" do
          let(:number) { 6.0 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::MultipleOf::Example4] " \
                "Output attribute `number` has the value `6.0`, which is not a multiple of `5.0`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:number).valid_with(attributes).type(Float).required
        )
      end
    end
  end
end
