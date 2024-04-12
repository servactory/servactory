# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Email::Basic::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email: email
      }
    end

    let(:email) { "noreply@servactory.com" }

    include_examples "check class info",
                     inputs: %i[email],
                     internals: %i[],
                     outputs: %i[email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:email?).with(true) }
        it { expect(perform).to have_output(:email).with("No Reply <noreply@servactory.com>") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `email`" do
          let(:email) { "noreply at servactory.com" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Email::Basic::Example1] " \
                "Input `email` does not match `email` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect(perform).to have_service_input(:email).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        email: email
      }
    end

    let(:email) { "noreply@servactory.com" }

    include_examples "check class info",
                     inputs: %i[email],
                     internals: %i[],
                     outputs: %i[email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:email?).with(true) }
        it { expect(perform).to have_output(:email).with("No Reply <noreply@servactory.com>") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `email`" do
          let(:email) { "noreply at servactory.com" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Email::Basic::Example1] " \
                "Input `email` does not match `email` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect(perform).to have_service_input(:email).type(String).required }
    end
  end
end
