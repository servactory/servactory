# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        issued_on: DateTime.new(2023, 1, 1)
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[issued_on]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  issued_on: {
                    type: [Date, DateTime, Time],
                    required: true,
                    prepare: be_a(Proc)
                  }
                }
              )
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:issued_on)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:issued_on, "2023-01-01")
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        issued_on: DateTime.new(2023, 1, 1)
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[issued_on]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  issued_on: {
                    type: [Date, DateTime, Time],
                    required: true,
                    prepare: be_a(Proc)
                  }
                }
              )
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:issued_on)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:issued_on, "2023-01-01")
        )
      end
    end
  end
end
