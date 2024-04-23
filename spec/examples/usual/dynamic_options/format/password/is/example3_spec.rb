# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Password::Is::Example3, type: :service do
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
                     internals: %i[],
                     outputs: %i[password]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:password?).with(true) }
        it { expect(perform).to have_output(:password).with("~hUN`AgY=YpW.061") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `password`" do
          let(:password) { "my-best-password" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::Format::Password::Is::Example3] " \
                "Output attribute `password` does not match `password` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:password).valid_with(attributes).type(String).required }
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
                     internals: %i[],
                     outputs: %i[password]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:password?).with(true) }
        it { expect(perform).to have_output(:password).with("~hUN`AgY=YpW.061") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `password`" do
          let(:password) { "my-best-password" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::DynamicOptions::Format::Password::Is::Example3] " \
                "Output attribute `password` does not match `password` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:password).valid_with(attributes).type(String).required }
    end
  end
end
