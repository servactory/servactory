# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Result::BeFailureServiceMatcher do
  subject { described_class.new }

  let(:failure_result) { Wrong::TestKit::Rspec::Matchers::FailureService.call(should_fail: true) }
  let(:success_result) { Usual::TestKit::Rspec::Matchers::SuccessService.call(data: "test") }
  let(:custom_failure_result) { Wrong::TestKit::Rspec::Matchers::CustomFailureService.call(error_type: :custom) }
  let(:base_failure_result) { Wrong::TestKit::Rspec::Matchers::CustomFailureService.call(error_type: :base) }

  describe "#supports_block_expectations?" do
    it "returns false" do
      expect(subject.supports_block_expectations?).to be false
    end
  end

  describe "#description" do
    it "returns 'service failure'" do
      expect(subject.description).to eq("service failure")
    end
  end

  describe "#matches?" do
    context "with failure result" do
      it "returns true with default type :base" do
        # base_failure_result has type :base by default from fail!
        expect(subject.matches?(base_failure_result)).to be true
      end
    end

    context "with success result" do
      it "returns false" do
        expect(subject.matches?(success_result)).to be false
      end
    end

    context "with non-Result object" do
      it "returns false for string" do
        expect(subject.matches?("not a result")).to be false
      end

      it "returns false for nil" do
        expect(subject.matches?(nil)).to be false
      end

      it "returns false for hash" do
        expect(subject.matches?({ error: "something" })).to be false
      end
    end
  end

  describe "#type" do
    context "when type matches" do
      it "returns true" do
        matcher = subject.type(:validation_error)
        expect(matcher.matches?(failure_result)).to be true
      end
    end

    context "when type doesn't match" do
      it "returns false" do
        matcher = subject.type(:wrong_type)
        expect(matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(subject.type(:validation_error)).to eq(subject)
    end
  end

  describe "#message" do
    context "when message matches" do
      it "returns true" do
        matcher = subject.type(:validation_error).message("Expected failure")
        expect(matcher.matches?(failure_result)).to be true
      end
    end

    context "when message doesn't match" do
      it "returns false" do
        matcher = subject.type(:validation_error).message("wrong message")
        expect(matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(subject.message("Expected failure")).to eq(subject)
    end
  end

  describe "#meta" do
    context "when meta matches" do
      it "returns true" do
        matcher = subject.type(:validation_error).meta(code: 422)
        expect(matcher.matches?(failure_result)).to be true
      end
    end

    context "when meta doesn't match" do
      it "returns false for wrong value" do
        matcher = subject.type(:validation_error).meta(code: 500)
        expect(matcher.matches?(failure_result)).to be false
      end

      it "returns false for wrong key" do
        matcher = subject.type(:validation_error).meta(wrong_key: 422)
        expect(matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(subject.meta(code: 422)).to eq(subject)
    end
  end

  describe "#with (custom failure class)" do
    context "when failure class matches" do
      it "returns true" do
        matcher = subject.with(Wrong::TestKit::Rspec::Matchers::CustomFailure).type(:custom)
        expect(matcher.matches?(custom_failure_result)).to be true
      end
    end

    context "when failure class doesn't match" do
      it "returns false" do
        matcher = subject.with(Wrong::TestKit::Rspec::Matchers::CustomFailure).type(:validation_error)
        expect(matcher.matches?(failure_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(subject.with(Wrong::TestKit::Rspec::Matchers::CustomFailure)).to eq(subject)
    end
  end

  describe "chained validation" do
    it "validates all conditions together" do
      matcher = subject
                .type(:validation_error)
                .message("Expected failure")
                .meta(code: 422)

      expect(matcher.matches?(failure_result)).to be true
    end

    it "fails when any condition doesn't match" do
      matcher = subject
                .type(:validation_error)
                .message("Expected failure")
                .meta(code: 500) # wrong meta

      expect(matcher.matches?(failure_result)).to be false
    end
  end

  describe "#failure_message" do
    context "with non-Result object" do
      before { subject.matches?("string") }

      it "describes the type error", :aggregate_failures do
        expect(subject.failure_message).to include("Servactory::Result")
        expect(subject.failure_message).to include("String")
      end
    end

    context "with success result" do
      before { subject.matches?(success_result) }

      it "describes success/failure mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("expected failure")
        expect(subject.failure_message).to include("got success")
      end
    end

    context "with wrong type" do
      before do
        subject.type(:wrong_type)
        subject.matches?(failure_result)
      end

      it "describes the type mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("Incorrect error type")
        expect(subject.failure_message).to include("wrong_type")
        expect(subject.failure_message).to include("validation_error")
      end
    end

    context "with wrong message" do
      before do
        subject.type(:validation_error).message("wrong message")
        subject.matches?(failure_result)
      end

      it "describes the message mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("Incorrect error message")
        expect(subject.failure_message).to include("wrong message")
        expect(subject.failure_message).to include("Expected failure")
      end
    end

    context "with wrong meta" do
      before do
        subject.type(:validation_error).meta(code: 500)
        subject.matches?(failure_result)
      end

      it "describes the meta mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("Incorrect error meta")
        expect(subject.failure_message).to include("500")
        expect(subject.failure_message).to include("422")
      end
    end

    context "with wrong failure class" do
      before do
        subject.with(Wrong::TestKit::Rspec::Matchers::CustomFailure).type(:validation_error)
        subject.matches?(failure_result)
      end

      it "describes the class mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("Incorrect instance error")
        expect(subject.failure_message).to include("CustomFailure")
      end
    end
  end

  describe "#failure_message_when_negated" do
    it "returns negation message" do
      expect(subject.failure_message_when_negated).to include("not to be a failed service")
    end
  end

  describe "fluent interface" do
    it "allows full chaining" do
      result = subject
               .with(Servactory::Exceptions::Failure)
               .type(:validation_error)
               .message("Expected failure")
               .meta(code: 422)

      expect(result).to eq(subject)
    end
  end

  describe "RSpec::Matchers::Composable inclusion" do
    it "includes RSpec::Matchers::Composable" do
      expect(described_class.included_modules).to include(RSpec::Matchers::Composable)
    end
  end
end
