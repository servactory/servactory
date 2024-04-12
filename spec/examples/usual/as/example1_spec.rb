# frozen_string_literal: true

RSpec.describe Usual::As::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email_address: email_address
      }
    end

    let(:email_address) { "noreply@servactory.com" }

    include_examples "check class info",
                     inputs: %i[email_address],
                     internals: %i[],
                     outputs: [:formatted_email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.formatted_email).to eq("No Reply <noreply@servactory.com>")
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:email_address).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        email_address: email_address
      }
    end

    let(:email_address) { "noreply@servactory.com" }

    include_examples "check class info",
                     inputs: %i[email_address],
                     internals: %i[],
                     outputs: [:formatted_email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.formatted_email).to eq("No Reply <noreply@servactory.com>")
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:email_address).type(String).required }
    end
  end
end
