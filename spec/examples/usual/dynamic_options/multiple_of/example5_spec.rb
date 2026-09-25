# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::MultipleOf::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 0.3 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: %i[number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .types(Integer, Float, Rational, BigDecimal)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:number)
              .types(Integer, Float, Rational, BigDecimal)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Float)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `number` is `0.3`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 0.3)
          )
        end
      end

      context "when `number` is `0.7`" do
        let(:number) { 0.7 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 0.7)
          )
        end
      end

      context "when `number` is `2.3`" do
        let(:number) { 2.3 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 2.3)
          )
        end
      end

      context "when `number` is `-0.3`" do
        let(:number) { -0.3 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, -0.3)
          )
        end
      end

      context "when `number` is `Integer`" do
        let(:number) { 7 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 7)
          )
        end
      end

      context "when `number` is `Rational`" do
        let(:number) { Rational(23, 10) }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, Rational(23, 10))
          )
        end
      end

      context "when `number` is `BigDecimal`" do
        let(:number) { BigDecimal("2.3") }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, BigDecimal("2.3"))
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "for `input` attribute" do
        context "when `number` is `0.35`" do
          let(:number) { 0.35 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::MultipleOf::Example5] " \
                "Input `number` has the value `0.35`, which is not a multiple of `0.1`"
              )
            )
          end
        end

        context "when `number` is `-0.35`" do
          let(:number) { -0.35 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::MultipleOf::Example5] " \
                "Input `number` has the value `-0.35`, which is not a multiple of `0.1`"
              )
            )
          end
        end
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

    let(:number) { 0.3 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[number],
                    outputs: %i[number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .types(Integer, Float, Rational, BigDecimal)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:number)
              .types(Integer, Float, Rational, BigDecimal)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Float)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `number` is `0.3`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 0.3)
          )
        end
      end

      context "when `number` is `0.7`" do
        let(:number) { 0.7 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 0.7)
          )
        end
      end

      context "when `number` is `2.3`" do
        let(:number) { 2.3 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 2.3)
          )
        end
      end

      context "when `number` is `-0.3`" do
        let(:number) { -0.3 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, -0.3)
          )
        end
      end

      context "when `number` is `Integer`" do
        let(:number) { 7 }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, 7)
          )
        end
      end

      context "when `number` is `Rational`" do
        let(:number) { Rational(23, 10) }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, Rational(23, 10))
          )
        end
      end

      context "when `number` is `BigDecimal`" do
        let(:number) { BigDecimal("2.3") }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:number, BigDecimal("2.3"))
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "for `input` attribute" do
        context "when `number` is `0.35`" do
          let(:number) { 0.35 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::MultipleOf::Example5] " \
                "Input `number` has the value `0.35`, which is not a multiple of `0.1`"
              )
            )
          end
        end

        context "when `number` is `-0.35`" do
          let(:number) { -0.35 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::MultipleOf::Example5] " \
                "Input `number` has the value `-0.35`, which is not a multiple of `0.1`"
              )
            )
          end
        end
      end
    end
  end
end
