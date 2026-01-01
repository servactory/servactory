# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example18, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        limited_number:
      }
    end

    let(:limited_number) { 50 }

    it_behaves_like "check class info",
                    inputs: %i[limited_number],
                    internals: %i[],
                    outputs: %i[limited_number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:limited_number, 50)
        )
      end
    end

    describe "and the value is at the boundary" do
      let(:limited_number) { 100 }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:limited_number, 100)
        )
      end
    end

    describe "and the value is negative" do
      let(:limited_number) { -1000 }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:limited_number, -1000)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `limited_number` is above limit" do
        let(:limited_number) { 101 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example18] Wrong value in `limited_number`, " \
              "must be one of `..100`, " \
              "got `101`"
            )
          )
        end
      end

      describe "because the value of `limited_number` is much above limit" do
        let(:limited_number) { 500 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example18] Wrong value in `limited_number`, " \
              "must be one of `..100`, " \
              "got `500`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:limited_number)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(..100)
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        limited_number:
      }
    end

    let(:limited_number) { 50 }

    it_behaves_like "check class info",
                    inputs: %i[limited_number],
                    internals: %i[],
                    outputs: %i[limited_number]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:limited_number, 50)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `limited_number` is above limit" do
        let(:limited_number) { 101 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example18] Wrong value in `limited_number`, " \
              "must be one of `..100`, " \
              "got `101`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:limited_number)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(..100)
          )
        end
      end
    end
  end
end
