# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Input::OptionalSubmatcher do
  subject { described_class.new(optional_context) }

  let(:optional_context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :age,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:age],
      i18n_root_key: "servactory"
    )
  end

  let(:required_context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :email,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:email],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'required'" do
      expect(subject.description).to include("required")
    end

    it "indicates false" do
      expect(subject.description).to include("false")
    end
  end

  describe "#matches?" do
    context "when input is optional" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end

      it "leaves missing_option empty" do
        subject.matches?(nil)
        expect(subject.missing_option).to eq("")
      end
    end

    context "when input is required" do
      subject { described_class.new(required_context) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option with failure message" do
        subject.matches?(nil)
        expect(subject.missing_option).not_to be_empty
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject { described_class.new(required_context) }

      before { subject.matches?(nil) }

      it "indicates expected optional state" do
        expect(subject.failure_message).to include("required: false")
      end

      it "indicates actual required state" do
        expect(subject.failure_message).to include("required: true")
      end
    end
  end
end
