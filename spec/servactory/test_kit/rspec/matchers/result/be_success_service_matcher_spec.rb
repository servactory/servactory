# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Result::BeSuccessServiceMatcher do
  subject { described_class.new }

  let(:success_result) { Usual::TestKit::Rspec::Matchers::SuccessService.call(data: "test") }
  let(:failure_result) { Wrong::TestKit::Rspec::Matchers::FailureService.call(should_fail: true) }

  describe "#supports_block_expectations?" do
    it "returns false" do
      expect(subject.supports_block_expectations?).to be false
    end
  end

  describe "#description" do
    it "returns 'service success'" do
      expect(subject.description).to eq("service success")
    end
  end

  describe "#matches?" do
    context "with successful result" do
      it "returns true" do
        expect(subject.matches?(success_result)).to be true
      end
    end

    context "with failure result" do
      it "returns false" do
        expect(subject.matches?(failure_result)).to be false
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
        expect(subject.matches?({ success: true })).to be false
      end
    end
  end

  describe "#with_output" do
    context "when output matches" do
      it "returns true" do
        matcher = subject.with_output(:result, "TEST")
        expect(matcher.matches?(success_result)).to be true
      end

      it "validates symbol output" do
        matcher = subject.with_output(:status, :completed)
        expect(matcher.matches?(success_result)).to be true
      end
    end

    context "when output doesn't match" do
      it "returns false for wrong value" do
        matcher = subject.with_output(:result, "wrong")
        expect(matcher.matches?(success_result)).to be false
      end

      it "returns false for non-existent output" do
        matcher = subject.with_output(:nonexistent, "value")
        expect(matcher.matches?(success_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(subject.with_output(:result, "TEST")).to eq(subject)
    end
  end

  describe "#with_outputs" do
    context "when all outputs match" do
      it "returns true" do
        matcher = subject.with_outputs(result: "TEST", status: :completed)
        expect(matcher.matches?(success_result)).to be true
      end
    end

    context "when any output doesn't match" do
      it "returns false for wrong value" do
        matcher = subject.with_outputs(result: "TEST", status: :wrong)
        expect(matcher.matches?(success_result)).to be false
      end
    end

    it "returns self for chaining" do
      expect(subject.with_outputs(result: "TEST")).to eq(subject)
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

    context "with failure result" do
      before { subject.matches?(failure_result) }

      it "describes success/failure mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("expected success")
        expect(subject.failure_message).to include("got failure")
      end
    end

    context "with non-existent output key" do
      before do
        subject.with_output(:nonexistent, "value")
        subject.matches?(success_result)
      end

      it "describes the missing key", :aggregate_failures do
        expect(subject.failure_message).to include("Non-existent value key")
        expect(subject.failure_message).to include("nonexistent")
      end
    end

    context "with wrong output value" do
      before do
        subject.with_output(:result, "wrong")
        subject.matches?(success_result)
      end

      it "describes the value mismatch", :aggregate_failures do
        expect(subject.failure_message).to include("Incorrect result value")
        expect(subject.failure_message).to include("result")
        expect(subject.failure_message).to include("wrong")
        expect(subject.failure_message).to include("TEST")
      end
    end
  end

  describe "#failure_message_when_negated" do
    it "returns negation message" do
      expect(subject.failure_message_when_negated).to include("not to be a successful service")
    end
  end

  describe "fluent interface" do
    it "allows chaining with_output and with_outputs", :aggregate_failures do
      expect(subject.with_output(:result, "TEST").with_outputs(status: :completed)).to eq(subject)
      expect(subject.matches?(success_result)).to be true
    end
  end

  describe "RSpec::Matchers::Composable inclusion" do
    it "includes RSpec::Matchers::Composable" do
      expect(described_class.included_modules).to include(RSpec::Matchers::Composable)
    end
  end
end
