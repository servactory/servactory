# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Base::MessageExpectation do
  subject(:expectation) { described_class.new(expected) }

  let(:expected) { "Value is invalid" }

  describe "#description" do
    it "inspects a String" do
      expect(expectation.description).to eq('"Value is invalid"')
    end

    context "with a Regexp" do
      let(:expected) { /invalid/ }

      it "inspects the Regexp" do
        expect(expectation.description).to eq("/invalid/")
      end
    end

    context "with an RSpec matcher" do
      let(:expected) { be_a(Proc) }

      it "uses the description of the matcher" do
        expect(expectation.description).to eq("be a kind of Proc")
      end
    end

    context "with a matcher without a description" do
      let(:expected) do
        Class.new do
          def matches?(actual)
            actual.is_a?(Proc)
          end

          def failure_message
            "expected a Proc"
          end

          def inspect
            "#<ProcMatcher>"
          end
        end.new
      end

      it "inspects the matcher" do
        expect(expectation.description).to eq("#<ProcMatcher>")
      end

      it "applies the matcher to the message" do
        expect(expectation.mismatch_for(-> {})).to be_nil
      end
    end
  end

  describe "#mismatch_for" do
    context "with a String" do
      it "returns nil for an equal message" do
        expect(expectation.mismatch_for("Value is invalid")).to be_nil
      end

      it "explains a message that differs only in case" do
        expect(expectation.mismatch_for("value is invalid")).to eq(<<~MESSAGE)
          expected "Value is invalid"
               got "value is invalid"
        MESSAGE
      end

      it "uses the default message when the message is blank" do
        expect(expectation.mismatch_for(nil, default_message: "Value is invalid")).to be_nil
      end
    end

    context "with a Regexp" do
      let(:expected) { /\AValue/ }

      it "returns nil for a matching message" do
        expect(expectation.mismatch_for("Value is invalid")).to be_nil
      end

      it "explains a message that does not match" do
        expect(expectation.mismatch_for("The value is invalid")).to include("expected /\\AValue/")
      end
    end

    context "with an RSpec matcher" do
      let(:expected) { be_a(Proc) }

      it "applies the matcher to the message as defined" do
        expect(expectation.mismatch_for(-> { "Value is invalid" })).to be_nil
      end

      it "does not use the default message" do
        expect(expectation.mismatch_for(nil, default_message: "Value is invalid")).to include("got nil")
      end
    end

    context "with a Proc message" do
      it "compares the built message" do
        expect(expectation.mismatch_for(-> {}) { "Value is invalid" }).to be_nil
      end

      it "explains a built message that is not a String" do
        expect(expectation.mismatch_for(-> {}) { :invalid }).to include("got :invalid, which is not a String")
      end

      it "explains an error raised while building the message", :aggregate_failures do
        mismatch = expectation.mismatch_for(-> {}) { raise ArgumentError, "missing keyword: :value" }

        expect(mismatch).to include('could not build the Proc message to compare with "Value is invalid"')
        expect(mismatch).to include("ArgumentError: missing keyword: :value")
      end
    end
  end
end
