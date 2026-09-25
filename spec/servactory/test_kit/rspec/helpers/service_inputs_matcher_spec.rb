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

    describe "#args_match?" do
      it "matches only required inputs" do
        expect(matcher.args_match?({ user_id: 1 })).to be(true)
      end

      it "matches required and optional inputs" do
        expect(matcher.args_match?({ user_id: 1, locale: "en", limit: 5 })).to be(true)
      end

      it "rejects inputs without a required input" do
        expect(matcher.args_match?({ locale: "en" })).to be(false)
      end

      it "rejects inputs with an unknown input" do
        expect(matcher.args_match?({ user_id: 1, page: 2 })).to be(false)
      end

      it "rejects a call without arguments" do
        expect(matcher.args_match?).to be(false)
      end

      it "matches String keys" do
        expect(matcher.args_match?({ "user_id" => 1, "locale" => "en" })).to be(true)
      end

      it "matches HashWithIndifferentAccess" do
        expect(matcher.args_match?(ActiveSupport::HashWithIndifferentAccess.new(user_id: 1))).to be(true)
      end

      it "rejects String keys without a required input" do
        expect(matcher.args_match?({ "locale" => "en" })).to be(false)
      end

      it "rejects an unknown String key" do
        expect(matcher.args_match?({ "user_id" => 1, "page" => 2 })).to be(false)
      end

      it "rejects HashWithIndifferentAccess with an unknown input" do
        expect(
          matcher.args_match?(ActiveSupport::HashWithIndifferentAccess.new(user_id: 1, page: 2))
        ).to be(false)
      end

      it "rejects a non-Hash argument" do
        expect(matcher.args_match?([[:user_id, 1]])).to be(false)
      end

      it "rejects more than one argument" do
        expect(matcher.args_match?({ user_id: 1 }, { locale: "en" })).to be(false)
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

    describe "#args_match?" do
      it "matches a call without arguments" do
        expect(matcher.args_match?).to be(true)
      end

      it "matches an empty Hash" do
        expect(matcher.args_match?({})).to be(true)
      end

      it "matches optional inputs" do
        expect(matcher.args_match?({ locale: "en" })).to be(true)
      end

      it "rejects an unknown input" do
        expect(matcher.args_match?({ page: 2 })).to be(false)
      end

      it "rejects a nil argument" do
        expect(matcher.args_match?(nil)).to be(false)
      end
    end

    describe "#description" do
      it "lists no required inputs" do
        expect(matcher.description).to eq("service_inputs(required: [], optional: [:locale])")
      end
    end
  end

  context "when service has no inputs" do
    let(:service_class) { Class.new(ApplicationService::Base) }

    describe "#args_match?" do
      it "matches a call without arguments" do
        expect(matcher.args_match?).to be(true)
      end

      it "matches an empty Hash" do
        expect(matcher.args_match?({})).to be(true)
      end

      it "rejects any input" do
        expect(matcher.args_match?({ page: 2 })).to be(false)
      end
    end

    describe "#description" do
      it "lists no inputs" do
        expect(matcher.description).to eq("service_inputs(required: [], optional: [])")
      end
    end
  end
end
