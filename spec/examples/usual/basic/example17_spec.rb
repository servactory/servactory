# frozen_string_literal: true

RSpec.describe Usual::Basic::Example17, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        need:
      }
    end

    let(:need) { false }

    it_behaves_like "check class info",
                    inputs: %i[need],
                    internals: %i[],
                    outputs: %i[need]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:need)
              .valid_with(attributes)
              .types(TrueClass, FalseClass)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:need)
              .instance_of(TrueClass, FalseClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      describe "when need is false" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:need, false)
          )
        end
      end

      describe "when need is true" do
        let(:need) { true }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:need, true)
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        need:
      }
    end

    let(:need) { false }

    it_behaves_like "check class info",
                    inputs: %i[need],
                    internals: %i[],
                    outputs: %i[need]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:need)
              .valid_with(attributes)
              .types(TrueClass, FalseClass)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:need)
              .instance_of(TrueClass, FalseClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      describe "when need is false" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:need, false)
          )
        end
      end

      describe "when need is true" do
        let(:need) { true }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:need, true)
          )
        end
      end
    end
  end
end
