# frozen_string_literal: true

RSpec.describe Usual::Stage::Example16, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        threshold:
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[threshold],
                    internals: %i[],
                    outputs: %i[number]

    describe "when threshold is greater than 5" do
      let(:threshold) { 10 }

      describe "validations" do
        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:number)
                .instance_of(Integer)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "executes high number stage" do
          expect(perform).to(
            be_success_service
              .with_output(:number, 10)
          )
        end
      end
    end

    describe "when threshold is less than or equal to 5" do
      let(:threshold) { 3 }

      describe "validations" do
        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:number)
                .instance_of(Integer)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "executes low number stage" do
          expect(perform).to(
            be_success_service
              .with_output(:number, 3)
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        threshold:
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[threshold],
                    internals: %i[],
                    outputs: %i[number]

    describe "when threshold is greater than 5" do
      let(:threshold) { 10 }

      describe "validations" do
        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:number)
                .instance_of(Integer)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "executes high number stage" do
          expect(perform).to(
            be_success_service
              .with_output(:number, 10)
          )
        end
      end
    end

    describe "when threshold is less than or equal to 5" do
      let(:threshold) { 3 }

      describe "validations" do
        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:number)
                .instance_of(Integer)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "executes low number stage" do
          expect(perform).to(
            be_success_service
              .with_output(:number, 3)
          )
        end
      end
    end
  end
end
