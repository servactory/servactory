# frozen_string_literal: true

RSpec.shared_examples "a submatcher" do
  it { is_expected.to respond_to(:matches?) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:failure_message) }
  it { is_expected.to respond_to(:failure_message_when_negated) }
  it { is_expected.to respond_to(:missing_option) }

  describe "#matches?" do
    it "returns boolean" do
      result = subject.matches?(nil)
      expect(result).to be(true).or be(false)
    end
  end

  describe "#description" do
    it "returns non-empty string", :aggregate_failures do
      expect(subject.description).to be_a(String)
      expect(subject.description).not_to be_empty
    end
  end
end
