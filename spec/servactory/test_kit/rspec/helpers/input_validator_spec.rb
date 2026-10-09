# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Helpers::InputValidator, type: :service do
  describe ".validate!" do
    subject(:validate) { described_class.validate!(service_class:, inputs_matcher:) }

    describe "with no_inputs matcher" do
      let(:inputs_matcher) { no_inputs }

      context "when service has no inputs" do
        let(:service_class) { Class.new(ApplicationService::Base) }

        it { expect { validate }.not_to raise_error }
      end

      context "when service has only optional inputs" do
        let(:service_class) do
          Class.new(ApplicationService::Base) do
            input :locale, type: String, required: false
            input :limit, type: Integer, required: false, default: 3
          end
        end

        it { expect { validate }.not_to raise_error }
      end

      context "when service has a required input" do
        let(:service_class) do
          Class.new(ApplicationService::Base) do
            input :user_id, type: Integer
            input :locale, type: String, required: false
          end
        end

        it "raises ValidationError listing only required inputs" do
          expect { validate }.to raise_error(
            described_class::ValidationError,
            /Required inputs: :user_id\. Hint/
          )
        end
      end

      context "when service has a required input in advanced mode" do
        let(:service_class) do
          Class.new(ApplicationService::Base) do
            input :user_id, type: Integer, required: { is: true, message: "User ID is required" }
          end
        end

        it "raises ValidationError listing the required input" do
          expect { validate }.to raise_error(
            described_class::ValidationError,
            /Required inputs: :user_id\. Hint/
          )
        end
      end
    end
  end
end
