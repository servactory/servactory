# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::ConsistsOfSubmatcher do
  subject { described_class.new(context, [String]) }

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :tags,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:tags],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'consists_of'" do
      expect(subject.description).to include("consists_of")
    end

    it "includes the type" do
      expect(subject.description).to include("String")
    end
  end

  describe "#matches?" do
    context "when consists_of matches" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end
    end

    context "when consists_of doesn't match" do
      subject { described_class.new(context, [Integer]) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option" do
        subject.matches?(nil)
        expect(subject.missing_option).not_to be_empty
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject { described_class.new(context, [Integer]) }

      before { subject.matches?(nil) }

      it "includes expected type" do
        expect(subject.failure_message).to include("Integer")
      end

      it "includes actual type" do
        expect(subject.failure_message).to include("String")
      end
    end
  end
end
