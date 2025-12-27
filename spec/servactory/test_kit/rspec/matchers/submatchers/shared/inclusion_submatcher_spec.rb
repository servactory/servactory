# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::InclusionSubmatcher do
  subject { described_class.new(context, %i[active inactive]) }

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :status,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:status],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'inclusion'" do
      expect(subject.description).to include("inclusion")
    end

    it "includes the values" do
      expect(subject.description).to include("active")
      expect(subject.description).to include("inactive")
    end
  end

  describe "#matches?" do
    context "when inclusion values match exactly" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end
    end

    context "when inclusion values don't match" do
      subject { described_class.new(context, %i[pending completed]) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option" do
        subject.matches?(nil)
        expect(subject.missing_option).not_to be_empty
      end
    end

    context "when inclusion values are subset" do
      subject { described_class.new(context, [:active]) }

      it "returns false (missing inactive)" do
        expect(subject.matches?(nil)).to be false
      end
    end

    context "when inclusion values are superset" do
      subject { described_class.new(context, %i[active inactive pending]) }

      it "returns false (extra pending)" do
        expect(subject.matches?(nil)).to be false
      end
    end

    context "when values match but in different order" do
      subject { described_class.new(context, %i[inactive active]) }

      it "returns true (order independent)" do
        expect(subject.matches?(nil)).to be true
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject { described_class.new(context, %i[pending completed]) }

      before { subject.matches?(nil) }

      it "includes expected values" do
        expect(subject.failure_message).to include("pending")
        expect(subject.failure_message).to include("completed")
      end
    end
  end
end
