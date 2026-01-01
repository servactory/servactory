# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids:
      }
    end

    let(:ids) do
      [
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        123,
        "",
        :identifier,
        nil,
        12.3
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        # NOTE: In this example, collection mode is disabled.
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Array)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:ids)
              .instance_of(Array)
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:ids?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:ids, ["6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3])
        )
      end

      it do
        expect(perform).to(
          have_output(:first_id?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:first_id, "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        )
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
      [
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        123,
        "",
        :identifier,
        nil,
        12.3
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        # NOTE: In this example, collection mode is disabled.
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Array)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:ids)
              .instance_of(Array)
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:ids?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:ids, ["6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3])
        )
      end

      it do
        expect(perform).to(
          have_output(:first_id?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:first_id, "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        )
      end
    end
  end
end
