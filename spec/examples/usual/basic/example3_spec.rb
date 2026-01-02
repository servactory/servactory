# frozen_string_literal: true

RSpec.describe Usual::Basic::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { nil }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:middle_name)
              .valid_with(attributes)
              .type(String)
              .optional
              .default("<unknown>")
          )
        end

        it do
          expect { perform }.to(
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:full_name)
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
            .with_output(:full_name, "John <unknown> Kennedy")
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { nil }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:middle_name)
              .valid_with(attributes)
              .type(String)
              .optional
              .default("<unknown>")
          )
        end

        it do
          expect { perform }.to(
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:full_name)
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
            .with_output(:full_name, "John <unknown> Kennedy")
        )
      end
    end
  end
end
