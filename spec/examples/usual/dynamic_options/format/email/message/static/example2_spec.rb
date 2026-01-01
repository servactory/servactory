# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Email::Message::Static::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email:
      }
    end

    let(:email) { "noreply@servactory.com" }

    it_behaves_like "check class info",
                    inputs: %i[email],
                    internals: %i[email],
                    outputs: %i[email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:email?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:email, "No Reply <noreply@servactory.com>")
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `email`" do
          let(:email) { "noreply at servactory.com" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid email format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:email).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        email:
      }
    end

    let(:email) { "noreply@servactory.com" }

    it_behaves_like "check class info",
                    inputs: %i[email],
                    internals: %i[email],
                    outputs: %i[email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:email?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:email, "No Reply <noreply@servactory.com>")
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `email`" do
          let(:email) { "noreply at servactory.com" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid email format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:email).valid_with(attributes).type(String).required }
    end
  end
end
