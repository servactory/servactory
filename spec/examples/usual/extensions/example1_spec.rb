# frozen_string_literal: true

RSpec.describe Usual::Extensions::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        user:
      }
    end

    let(:user) { Usual::Extensions::Example1::User.new(active: true) }

    it_behaves_like "check class info",
                    inputs: %i[user],
                    internals: %i[],
                    outputs: %i[]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected values", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).to be_success
        expect(result).not_to be_failure
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the user is not active" do
        let(:user) { Usual::Extensions::Example1::User.new(active: false) }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "User is not active"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:user)
            .valid_with(attributes)
            .type(Usual::Extensions::Example1::User)
            .required
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        user:
      }
    end

    let(:user) { Usual::Extensions::Example1::User.new(active: true) }

    it_behaves_like "check class info",
                    inputs: %i[user],
                    internals: %i[],
                    outputs: %i[]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected values", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).to be_success
        expect(result).not_to be_failure
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the user is not active" do
        let(:user) { Usual::Extensions::Example1::User.new(active: false) }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "User is not active"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:user)
            .valid_with(attributes)
            .type(Usual::Extensions::Example1::User)
            .required
        )
      end
    end
  end
end
