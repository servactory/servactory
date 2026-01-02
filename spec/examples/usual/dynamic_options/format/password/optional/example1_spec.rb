# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Password::Optional::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        password:
      }
    end

    let(:password) { nil }

    it_behaves_like "check class info",
                    inputs: %i[password],
                    internals: %i[],
                    outputs: %i[password]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              password: nil,
              password?: false
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `password`" do
        let(:password) { "my-best-password" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Password::Optional::Example1] " \
              "Input `password` does not match `password` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:password)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:password)
              .instance_of(NilClass)
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        password:
      }
    end

    let(:password) { nil }

    it_behaves_like "check class info",
                    inputs: %i[password],
                    internals: %i[],
                    outputs: %i[password]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              password: nil,
              password?: false
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `password`" do
        let(:password) { "my-best-password" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Password::Optional::Example1] " \
              "Input `password` does not match `password` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:password)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:password)
              .instance_of(NilClass)
          )
        end
      end
    end
  end
end
