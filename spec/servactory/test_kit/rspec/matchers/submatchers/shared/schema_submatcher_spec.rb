# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::SchemaSubmatcher do
  subject { described_class.new(context, { key: { type: String } }) }

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :config,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:config],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'schema'" do
      expect(subject.description).to include("schema")
    end

    it "includes the schema structure" do
      expect(subject.description).to include("key")
    end
  end

  describe "#matches?" do
    context "when schema matches exactly" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end

      it "leaves missing_option empty" do
        subject.matches?(nil)
        expect(subject.missing_option).to eq("")
      end
    end

    context "when schema doesn't match" do
      subject { described_class.new(context, { different_key: { type: Integer } }) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option with failure message" do
        subject.matches?(nil)
        expect(subject.missing_option).not_to be_empty
      end
    end

    context "when expected schema is empty" do
      subject { described_class.new(context, {}) }

      it "returns true (empty schema matches anything)" do
        expect(subject.matches?(nil)).to be true
      end
    end

    context "when expected schema is nil" do
      subject { described_class.new(context, nil) }

      it "returns true (nil schema matches anything)" do
        expect(subject.matches?(nil)).to be true
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject { described_class.new(context, { wrong: { type: String } }) }

      before { subject.matches?(nil) }

      it "includes expected schema" do
        expect(subject.failure_message).to include("wrong")
      end

      it "includes actual schema" do
        expect(subject.failure_message).to include("key")
      end

      it "describes the failure" do
        expect(subject.failure_message).to include("schema")
      end
    end
  end
end
