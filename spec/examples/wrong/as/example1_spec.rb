# frozen_string_literal: true

RSpec.describe Wrong::As::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids:
      }
    end

    let(:ids) do
      %w[
        6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
        bdd30bb6-c6ab-448d-8302-7018de07b9a4
        e864b5e7-e515-4d5e-9a7e-7da440323390
        b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[],
                    outputs: %i[first_id]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::As::Example1] Undefined input attribute `ids`"
          )
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          # FIXME: Add example for `as` (internal_name)
          expect { perform }.to(
            have_input(:ids)
              .valid_with(false)
              .type(Array)
              .consists_of(String)
              .required
          )
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:first_id)
                .instance_of(String)
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
        ids:
      }
    end

    let(:ids) do
      %w[
        6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
        bdd30bb6-c6ab-448d-8302-7018de07b9a4
        e864b5e7-e515-4d5e-9a7e-7da440323390
        b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[],
                    outputs: %i[first_id]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::As::Example1] Undefined input attribute `ids`"
          )
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          # FIXME: Add example for `as` (internal_name)
          expect { perform }.to(
            have_input(:ids)
              .valid_with(false)
              .type(Array)
              .consists_of(String)
              .required
          )
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:first_id)
                .instance_of(String)
            )
          end
        end
      end
    end
  end
end
