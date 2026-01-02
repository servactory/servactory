# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example16, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 25 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[adjusted_number],
                    outputs: %i[final_number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:final_number, 25)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `number` is outside input range" do
        let(:number) { 150 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example16] Wrong value in `number`, " \
              "must be one of `1..100`, " \
              "got `150`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(1..100)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:final_number)
              .instance_of(Integer)
          )
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

    let(:number) { 25 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[adjusted_number],
                    outputs: %i[final_number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:final_number, 25)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `number` is outside input range" do
        let(:number) { 150 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example16] Wrong value in `number`, " \
              "must be one of `1..100`, " \
              "got `150`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(1..100)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:final_number)
              .instance_of(Integer)
          )
        end
      end
    end
  end
end
