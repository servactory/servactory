# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Password::Message::Static::Example2 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        password: password
      }
    end

    let(:password) { "~hUN`AgY=YpW.061" }

    include_examples "check class info",
                     inputs: %i[password],
                     internals: %i[password],
                     outputs: %i[password]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.password?).to be(true)
          expect(result.password).to eq("~hUN`AgY=YpW.061")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `password`" do
          let(:password) { "my-best-password" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :password

        it_behaves_like "input type check", name: :password, expected_type: String
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        password: password
      }
    end

    let(:password) { "~hUN`AgY=YpW.061" }

    include_examples "check class info",
                     inputs: %i[password],
                     internals: %i[password],
                     outputs: %i[password]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.password?).to be(true)
          expect(result.password).to eq("~hUN`AgY=YpW.061")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `password`" do
          let(:password) { "my-best-password" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "Invalid date format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `data`" do
        it_behaves_like "input required check", name: :password

        it_behaves_like "input type check", name: :password, expected_type: String
      end
    end
  end
end
