# frozen_string_literal: true

RSpec.describe Usual::Basic::Example17, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name last_name],
                    internals: %i[],
                    outputs: %i[full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required("[Usual::Basic::Example17] Input `first_name` is required, got nil")
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
            .with_output(:full_name, "John Kennedy")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `first_name` is not specified" do
        let(:first_name) { nil }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Basic::Example17] Input `first_name` is required, got nil"
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
        first_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name last_name],
                    internals: %i[],
                    outputs: %i[full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required("[Usual::Basic::Example17] Input `first_name` is required, got nil")
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
            .with_output(:full_name, "John Kennedy")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `first_name` is not specified" do
        let(:first_name) { nil }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Basic::Example17] Input `first_name` is required, got nil"
            )
          )
        end
      end
    end
  end
end
