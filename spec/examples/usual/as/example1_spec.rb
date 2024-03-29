# frozen_string_literal: true

RSpec.describe Usual::As::Example1 do
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
      context "when `email_address`" do
        it_behaves_like "input required check", name: :email_address
        it_behaves_like "input type check", name: :email_address, expected_type: String
      end
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
      context "when `email_address`" do
        it_behaves_like "input required check", name: :email_address
        it_behaves_like "input type check", name: :email_address, expected_type: String
      end
    end
  end
end
