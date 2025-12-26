# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::MustSubmatcher do
  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :score,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:score],
      i18n_root_key: "servactory"
    )
  end

  subject { described_class.new(context, [:be_positive]) }

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'must'" do
      expect(subject.description).to include("must")
    end

    it "includes the must name" do
      expect(subject.description).to include("be_positive")
    end

    context "with multiple must conditions" do
      subject { described_class.new(context, %i[be_positive be_even]) }

      it "includes all must names" do
        expect(subject.description).to include("be_positive")
        expect(subject.description).to include("be_even")
      end
    end
  end

  describe "#matches?" do
    context "when must conditions match" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end
    end

    context "when must conditions don't match" do
      subject { described_class.new(context, [:be_even]) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end
    end

    context "when expected is superset of actual" do
      subject { described_class.new(context, %i[be_positive be_even]) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end
    end
  end
end
