# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example17, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        positive_number:
      }
    end

    let(:positive_number) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[positive_number],
                    internals: %i[],
                    outputs: %i[positive_number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:positive_number)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(1..)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:positive_number)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:positive_number, 42)
        )
      end
    end

    describe "and the value is at the boundary" do
      let(:positive_number) { 1 }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:positive_number, 1)
        )
      end
    end

    describe "and the value is very large" do
      let(:positive_number) { 1_000_000 }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:positive_number, 1_000_000)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `positive_number` is zero" do
        let(:positive_number) { 0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example17] Wrong value in `positive_number`, " \
              "must be one of `1..`, " \
              "got `0`"
            )
          )
        end
      end

      describe "because the value of `positive_number` is negative" do
        let(:positive_number) { -5 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example17] Wrong value in `positive_number`, " \
              "must be one of `1..`, " \
              "got `-5`"
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
        positive_number:
      }
    end

    let(:positive_number) { 42 }

    it_behaves_like "check class info",
                    inputs: %i[positive_number],
                    internals: %i[],
                    outputs: %i[positive_number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:positive_number)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(1..)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:positive_number)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:positive_number, 42)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `positive_number` is zero" do
        let(:positive_number) { 0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example17] Wrong value in `positive_number`, " \
              "must be one of `1..`, " \
              "got `0`"
            )
          )
        end
      end
    end
  end
end
