# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Password::Message::Static::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        password:
      }
    end

    let(:password) { "~hUN`AgY=YpW.061" }

    it_behaves_like "check class info",
                    inputs: %i[password],
                    internals: %i[],
                    outputs: %i[password]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:password, "~hUN`AgY=YpW.061")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `password`" do
        let(:password) { "my-best-password" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Invalid date format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:password)
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
        password:
      }
    end

    let(:password) { "~hUN`AgY=YpW.061" }

    it_behaves_like "check class info",
                    inputs: %i[password],
                    internals: %i[],
                    outputs: %i[password]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:password, "~hUN`AgY=YpW.061")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `password`" do
        let(:password) { "my-best-password" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Invalid date format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:password)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end
    end
  end
end
