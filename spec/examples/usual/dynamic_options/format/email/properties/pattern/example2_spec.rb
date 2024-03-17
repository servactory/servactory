# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Email::Properties::Pattern::Example2 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email: email
      }
    end

    let(:email) { "noreply at servactory.com" }

    include_examples "check class info",
                     inputs: %i[email],
                     internals: %i[email],
                     outputs: %i[email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.email?).to be(true)
          expect(result.email).to eq("No Reply <noreply at servactory.com>")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:email) { " " }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Email::Properties::Pattern::Example2] " \
                "Internal attribute `email` does not match `email` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :email

        it_behaves_like "input type check", name: :email, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        email: email
      }
    end

    let(:email) { "noreply at servactory.com" }

    include_examples "check class info",
                     inputs: %i[email],
                     internals: %i[email],
                     outputs: %i[email]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.email?).to be(true)
          expect(result.email).to eq("No Reply <noreply at servactory.com>")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `date`" do
          let(:email) { " " }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Email::Properties::Pattern::Example2] " \
                "Internal attribute `email` does not match `email` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :email

        it_behaves_like "input type check", name: :email, expected_type: String
      end
    end
  end
end
