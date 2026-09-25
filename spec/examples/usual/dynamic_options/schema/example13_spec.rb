# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example13, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        meta: { a: "ok" },
        name: "John"
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[payload]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  meta: {
                    type: Hash,
                    a: { type: String }
                  },
                  name: { type: String }
                }
              )
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(Hash)
              .schema(
                {
                  meta: {
                    type: Hash,
                    a: { type: String }
                  },
                  name: { type: String }
                }
              )
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payload, { meta: { a: "ok" }, name: "John" })
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
        meta: { a: "ok" },
        name: "John"
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[payload]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  meta: {
                    type: Hash,
                    a: { type: String }
                  },
                  name: { type: String }
                }
              )
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(Hash)
              .schema(
                {
                  meta: {
                    type: Hash,
                    a: { type: String }
                  },
                  name: { type: String }
                }
              )
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payload, { meta: { a: "ok" }, name: "John" })
        )
      end
    end
  end
end
