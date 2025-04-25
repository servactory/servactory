# frozen_string_literal: true

RSpec.describe Usual::Conditions::Example6, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        locked:
      }
    end

    let(:locked) { false }

    it_behaves_like "check class info",
                    inputs: %i[locked],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:locked)
              # NOTE: Not used due to `ApplicationService::Exceptions::Failure`.
              # .valid_with(attributes)
              .types(TrueClass, FalseClass)
              .optional
              .default(true)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Integer)
          )
        end
      end
    end

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:number).contains(7) }
      end

      describe "but the data required for work is invalid" do
        describe "because the input `locked` is `nil`" do
          let(:locked) { nil }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
                expect(exception.type).to eq(:base)
                expect(exception.message).to eq("Locked!")
                expect(exception.meta).to be_nil
              end
            )
          end
        end

        describe "because the input `locked` is `\"\"`" do
          let(:locked) { "" }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
                expect(exception.type).to eq(:base)
                expect(exception.message).to eq("Locked!")
                expect(exception.meta).to be_nil
              end
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
        locked:
      }
    end

    let(:locked) { false }

    it_behaves_like "check class info",
                    inputs: %i[locked],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:locked)
              # NOTE: Not used due to `ApplicationService::Exceptions::Failure`.
              # .valid_with(attributes)
              .types(TrueClass, FalseClass)
              .optional
              .default(true)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:number)
              .instance_of(Integer)
          )
        end
      end
    end

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:number).contains(7) }
      end

      describe "but the data required for work is invalid" do
        describe "because the input `locked` is `nil`" do
          let(:locked) { nil }

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
            expect(result.error).to an_object_having_attributes(
              type: :base,
              message: "Locked!",
              meta: nil
            )
          end
        end

        describe "because the input `locked` is `\"\"`" do
          let(:locked) { "" }

          it "returns the expected value in `errors`", :aggregate_failures do
            result = perform

            expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
            expect(result.error).to an_object_having_attributes(
              type: :base,
              message: "Locked!",
              meta: nil
            )
          end
        end
      end
    end
  end
end
