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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.formatted_email).to eq("No Reply <noreply@servactory.com>")
        end
      end
    end

    context "when the input arguments are invalid" do
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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.formatted_email).to eq("No Reply <noreply@servactory.com>")
        end
      end
    end

    context "when the input arguments are invalid" do
      it {
        expect do
          perform
        end.to have_input(:email_address).valid_with(attributes).type(String).required
      }
    end
  end
end
