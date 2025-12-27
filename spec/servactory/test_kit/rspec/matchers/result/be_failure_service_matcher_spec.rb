# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Result::BeFailureServiceMatcher do
  subject(:matcher) { described_class.new }

  let(:failure_result) { Wrong::TestKit::Rspec::Matchers::FailureService.call(should_fail: true) }
  let(:success_result) { Usual::TestKit::Rspec::Matchers::SuccessService.call(data: "test") }
  let(:custom_failure_result) { Wrong::TestKit::Rspec::Matchers::CustomFailureService.call(error_type: :custom) }
  let(:base_failure_result) { Wrong::TestKit::Rspec::Matchers::CustomFailureService.call(error_type: :base) }

  describe "#supports_block_expectations?" do
    it "returns false" do
      expect(matcher.supports_block_expectations?).to be false
    end
  end

  describe "#description" do
    it "returns 'service failure'" do
      expect(matcher.description).to eq("service failure")
    end
  end

  describe "#matches?" do
    context "with failure result" do
      it "returns true with default type :base" do
        # base_failure_result has type :base by default from fail!
        expect(matcher.matches?(base_failure_result)).to be true
      end
    end

    context "with success result" do
      it "returns false" do
        expect(matcher.matches?(success_result)).to be false
      end
    end

    context "with non-Result object" do
      it "returns false for string" do
        expect(matcher.matches?("not a result")).to be false
      end

      it "returns false for nil" do
        expect(matcher.matches?(nil)).to be false
      end

      it "returns false for hash" do
        expect(matcher.matches?({ error: "something" })).to be false
      end
    end
  end

  describe "#type" do
    context "when type matches" do
      it "returns true" do
        chained_matcher = matcher.type(:validation_error)
        expect(chained_matcher.matches?(failure_result)).to be true
      end
    end

    context "when type doesn't match" do
      it "returns false" do
        chained_matcher = matcher.type(:wrong_type)
        expect(chained_matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(matcher.type(:validation_error)).to eq(matcher)
    end
  end

  describe "#message" do
    context "when message matches" do
      it "returns true" do
        chained_matcher = matcher.type(:validation_error).message("Expected failure")
        expect(chained_matcher.matches?(failure_result)).to be true
      end
    end

    context "when message doesn't match" do
      it "returns false" do
        chained_matcher = matcher.type(:validation_error).message("wrong message")
        expect(chained_matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(matcher.message("Expected failure")).to eq(matcher)
    end
  end

  describe "#meta" do
    context "when meta matches" do
      it "returns true" do
        chained_matcher = matcher.type(:validation_error).meta(code: 422)
        expect(chained_matcher.matches?(failure_result)).to be true
      end
    end

    context "when meta doesn't match" do
      it "returns false for wrong value" do
        chained_matcher = matcher.type(:validation_error).meta(code: 500)
        expect(chained_matcher.matches?(failure_result)).to be false
      end

      it "returns false for wrong key" do
        chained_matcher = matcher.type(:validation_error).meta(wrong_key: 422)
        expect(chained_matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(matcher.meta(code: 422)).to eq(matcher)
    end
  end

  describe "#with (custom failure class)" do
    context "when failure class matches" do
      it "returns true" do
        chained_matcher = matcher.with(Wrong::TestKit::Rspec::Matchers::CustomFailure).type(:custom)
        expect(chained_matcher.matches?(custom_failure_result)).to be true
      end
    end

    context "when failure class doesn't match" do
      it "returns false" do
        chained_matcher = matcher.with(Wrong::TestKit::Rspec::Matchers::CustomFailure).type(:validation_error)
        expect(chained_matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(matcher.with(Wrong::TestKit::Rspec::Matchers::CustomFailure)).to eq(matcher)
    end
  end

  describe "chained validation" do
    it "validates all conditions together" do
      chained_matcher = matcher
                        .type(:validation_error)
                        .message("Expected failure")
                        .meta(code: 422)

      expect(chained_matcher.matches?(failure_result)).to be true
    end

    it "fails when any condition doesn't match" do
      chained_matcher = matcher
                        .type(:validation_error)
                        .message("Expected failure")
                        .meta(code: 500) # wrong meta

      expect(chained_matcher.matches?(failure_result)).to be false
    end
  end

  describe "#failure_message" do
    context "with non-Result object" do
      before { matcher.matches?("string") }

      it "describes the type error", :aggregate_failures do
        expect(matcher.failure_message).to include("Servactory::Result")
        expect(matcher.failure_message).to include("String")
      end
    end

    context "with success result" do
      before { matcher.matches?(success_result) }

      it "describes success/failure mismatch", :aggregate_failures do
        expect(matcher.failure_message).to include("expected failure")
        expect(matcher.failure_message).to include("got success")
      end
    end

    context "with wrong type" do
      before do
        matcher.type(:wrong_type)
        matcher.matches?(failure_result)
      end

      it "describes the type mismatch", :aggregate_failures do
        expect(matcher.failure_message).to include("Incorrect error type")
        expect(matcher.failure_message).to include("wrong_type")
        expect(matcher.failure_message).to include("validation_error")
      end
    end

    context "with wrong message" do
      before do
        matcher.type(:validation_error).message("wrong message")
        matcher.matches?(failure_result)
      end

      it "describes the message mismatch", :aggregate_failures do
        expect(matcher.failure_message).to include("Incorrect error message")
        expect(matcher.failure_message).to include("wrong message")
        expect(matcher.failure_message).to include("Expected failure")
      end
    end

    context "with wrong meta" do
      before do
        matcher.type(:validation_error).meta(code: 500)
        matcher.matches?(failure_result)
      end

      it "describes the meta mismatch", :aggregate_failures do
        expect(matcher.failure_message).to include("Incorrect error meta")
        expect(matcher.failure_message).to include("500")
        expect(matcher.failure_message).to include("422")
      end
    end

    context "with wrong failure class" do
      before do
        matcher.with(Wrong::TestKit::Rspec::Matchers::CustomFailure).type(:validation_error)
        matcher.matches?(failure_result)
      end

      it "describes the class mismatch", :aggregate_failures do
        expect(matcher.failure_message).to include("Incorrect instance error")
        expect(matcher.failure_message).to include("CustomFailure")
      end
    end
  end

  describe "#failure_message_when_negated" do
    it "returns negation message" do
      expect(matcher.failure_message_when_negated).to include("not to be a failed service")
    end
  end

  describe "fluent interface" do
    it "allows full chaining" do
      result = matcher
               .with(Servactory::Exceptions::Failure)
               .type(:validation_error)
               .message("Expected failure")
               .meta(code: 422)

      expect(result).to eq(matcher)
    end
  end

  describe "RSpec::Matchers::Composable inclusion" do
    it "includes RSpec::Matchers::Composable" do
      expect(described_class.included_modules).to include(RSpec::Matchers::Composable)
    end
  end
end
