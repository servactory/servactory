# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Email::Properties::Validator::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email:
      }
    end

    let(:email) { "noreply at servactory.com" }

    it_behaves_like "check class info",
                    inputs: %i[email],
                    internals: %i[],
                    outputs: %i[email]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:email)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:email)
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
            .with_output(:email, "noreply at servactory.com")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `email`" do
        let(:email) { "noreply@servactory.com" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Usual::DynamicOptions::Format::Email::Properties::Validator::Example3] " \
              "Output attribute `email` does not match `email` format"
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
        email:
      }
    end

    let(:email) { "noreply at servactory.com" }

    it_behaves_like "check class info",
                    inputs: %i[email],
                    internals: %i[],
                    outputs: %i[email]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:email)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:email)
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
            .with_output(:email, "noreply at servactory.com")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `email`" do
        let(:email) { "noreply@servactory.com" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Usual::DynamicOptions::Format::Email::Properties::Validator::Example3] " \
              "Output attribute `email` does not match `email` format"
            )
          )
        end
      end
    end
  end
end
