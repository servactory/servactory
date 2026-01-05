# frozen_string_literal: true

RSpec.shared_examples "an attribute matcher" do
  it { is_expected.to respond_to(:matches?) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:failure_message) }
  it { is_expected.to respond_to(:failure_message_when_negated) }
  it { is_expected.to respond_to(:supports_block_expectations?) }

  describe "#supports_block_expectations?" do
    it "returns true" do
      expect(subject.supports_block_expectations?).to be(true)
    end
  end

  describe "fluent interface" do
    it "chain methods return self" do
      expect(subject.type(String)).to eq(subject)
    end
  end
end
