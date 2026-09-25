# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Helpers::ServiceInputsMatcher do
  let(:matcher) { described_class.new(service_class.info.inputs) }

  context "when service has required and optional inputs" do
    let(:service_class) do
      Class.new(ApplicationService::Base) do
        input :user_id, type: Integer
        input :locale, type: String, required: false
        input :limit, type: Integer, required: false, default: 3
      end
    end

    describe "#===" do
      subject { arguments }

      context "with only required inputs" do
        let(:arguments) { { user_id: 1 } }

        it { is_expected.to match(matcher) }
      end

      context "with required and optional inputs" do
        let(:arguments) { { user_id: 1, locale: "en", limit: 5 } }

        it { is_expected.to match(matcher) }
      end

      context "without a required input" do
        let(:arguments) { { locale: "en" } }

        it { is_expected.not_to match(matcher) }
      end

      context "with an unknown input" do
        let(:arguments) { { user_id: 1, page: 2 } }

        it { is_expected.not_to match(matcher) }
      end

      context "with string keys" do
        let(:arguments) { { "user_id" => 1 } }

        it { is_expected.not_to match(matcher) }
      end

      context "with a non-Hash argument" do
        let(:arguments) { [[:user_id, 1]] }

        it { is_expected.not_to match(matcher) }
      end
    end

    describe "#description" do
      it "lists required and optional inputs" do
        expect(matcher.description).to eq("service_inputs(required: [:user_id], optional: [:locale, :limit])")
      end
    end

    describe "#inspect" do
      it "returns the description" do
        expect(matcher.inspect).to eq(matcher.description)
      end
    end
  end

  context "when service has only optional inputs" do
    let(:service_class) do
      Class.new(ApplicationService::Base) do
        input :locale, type: String, required: false
      end
    end

    describe "#===" do
      subject { arguments }

      context "without inputs" do
        let(:arguments) { {} }

        it { is_expected.to match(matcher) }
      end

      context "with an unknown input" do
        let(:arguments) { { page: 2 } }

        it { is_expected.not_to match(matcher) }
      end
    end

    describe "#description" do
      it "lists no required inputs" do
        expect(matcher.description).to eq("service_inputs(required: [], optional: [:locale])")
      end
    end
  end
end
