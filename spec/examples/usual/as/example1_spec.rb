# frozen_string_literal: true

RSpec.describe Usual::As::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email_address:
      }
    end

    let(:email_address) { "noreply@servactory.com" }

    it_behaves_like "check class info",
                    inputs: %i[email_address],
                    internals: %i[],
                    outputs: [:formatted_email]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:formatted_email, "No Reply <noreply@servactory.com>")
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:email_address)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        email_address:
      }
    end

    let(:email_address) { "noreply@servactory.com" }

    it_behaves_like "check class info",
                    inputs: %i[email_address],
                    internals: %i[],
                    outputs: [:formatted_email]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:formatted_email, "No Reply <noreply@servactory.com>")
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:email_address)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end
    end
  end
end
