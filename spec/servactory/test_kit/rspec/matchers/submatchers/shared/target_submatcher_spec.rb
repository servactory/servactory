# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::TargetSubmatcher do
  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :options,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:options],
      i18n_root_key: "servactory"
    )
  end

  subject { described_class.new(context, :target, %i[sidekiq]) }

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes option name" do
      expect(subject.description).to include("target")
    end

    it "includes the values" do
      expect(subject.description).to include("sidekiq")
    end

    context "with multiple values" do
      subject { described_class.new(context, :target, %i[sidekiq active_job]) }

      it "includes all values" do
        description = subject.description
        expect(description).to include("sidekiq")
        expect(description).to include("active_job")
      end
    end

    context "with class value" do
      subject { described_class.new(context, :target, [String]) }

      it "includes class name" do
        expect(subject.description).to include("String")
      end
    end

    context "with nil value" do
      subject { described_class.new(context, :target, [nil]) }

      it "shows nil as string" do
        expect(subject.description).to include("nil")
      end
    end
  end

  describe "#matches?" do
    context "when target values match exactly" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end

      it "leaves missing_option empty" do
        subject.matches?(nil)
        expect(subject.missing_option).to eq("")
      end
    end

    context "when target values don't match" do
      subject { described_class.new(context, :target, %i[wrong_target]) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option with failure message" do
        subject.matches?(nil)
        expect(subject.missing_option).not_to be_empty
      end
    end

    context "when target values are subset" do
      subject { described_class.new(context, :target, []) }

      it "returns false (missing sidekiq)" do
        expect(subject.matches?(nil)).to be false
      end
    end

    context "when target values are superset" do
      subject { described_class.new(context, :target, %i[sidekiq extra]) }

      it "returns false (extra value)" do
        expect(subject.matches?(nil)).to be false
      end
    end

    context "when attribute has no target option" do
      let(:context_without_target) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
          attribute_type: :input,
          attribute_name: :name,
          attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:name],
          i18n_root_key: "servactory"
        )
      end

      subject { described_class.new(context_without_target, :target, %i[sidekiq]) }

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject { described_class.new(context, :target, %i[wrong_target]) }

      before { subject.matches?(nil) }

      it "includes expected values" do
        expect(subject.failure_message).to include("wrong_target")
      end

      it "includes actual values" do
        expect(subject.failure_message).to include("sidekiq")
      end

      it "describes the option name" do
        expect(subject.failure_message).to include("target")
      end
    end
  end
end
