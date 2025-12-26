# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Input::DefaultSubmatcher do
  let(:context_with_default) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :age,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:age],
      i18n_root_key: "servactory"
    )
  end

  let(:context_without_default) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :name,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:name],
      i18n_root_key: "servactory"
    )
  end

  subject { described_class.new(context_with_default, 18) }

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'default'" do
      expect(subject.description).to include("default")
    end

    it "includes the expected value" do
      expect(subject.description).to include("18")
    end

    context "with nil expected value" do
      subject { described_class.new(context_without_default, nil) }

      it "shows nil in description" do
        expect(subject.description).to include("nil")
      end
    end

    context "with string expected value" do
      subject { described_class.new(context_with_default, "test") }

      it "shows string value in description" do
        expect(subject.description).to include("test")
      end
    end
  end

  describe "#matches?" do
    context "when default value matches" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end

      it "leaves missing_option empty" do
        subject.matches?(nil)
        expect(subject.missing_option).to eq("")
      end
    end

    context "when default value doesn't match" do
      subject { described_class.new(context_with_default, 21) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option with failure message" do
        subject.matches?(nil)
        expect(subject.missing_option).not_to be_empty
      end
    end

    context "when no default is set and expecting nil" do
      subject { described_class.new(context_without_default, nil) }

      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end
    end

    context "when no default is set but expecting a value" do
      subject { described_class.new(context_without_default, 25) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end
    end

    context "when default exists but expecting nil" do
      subject { described_class.new(context_with_default, nil) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject { described_class.new(context_with_default, 21) }

      before { subject.matches?(nil) }

      it "includes expected value" do
        expect(subject.failure_message).to include("21")
      end

      it "includes actual value" do
        expect(subject.failure_message).to include("18")
      end

      it "describes the failure" do
        expect(subject.failure_message).to include("default")
      end
    end
  end
end
