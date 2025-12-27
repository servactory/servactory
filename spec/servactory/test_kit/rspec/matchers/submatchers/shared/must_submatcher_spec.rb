# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::MustSubmatcher do
  subject(:submatcher) { described_class.new(context, [:be_positive]) }

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :score,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:score],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'must'" do
      expect(submatcher.description).to include("must")
    end

    it "includes the must name" do
      expect(submatcher.description).to include("be_positive")
    end

    context "with multiple must conditions" do
      subject(:submatcher) { described_class.new(context, %i[be_positive be_even]) }

      it "includes all must names", :aggregate_failures do
        expect(submatcher.description).to include("be_positive")
        expect(submatcher.description).to include("be_even")
      end
    end
  end

  describe "#matches?" do
    context "when must conditions match" do
      it "returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "when must conditions don't match" do
      subject(:submatcher) { described_class.new(context, [:be_even]) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "when expected is superset of actual" do
      subject(:submatcher) { described_class.new(context, %i[be_positive be_even]) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "when attribute has inclusion dynamic option" do
      subject(:submatcher) { described_class.new(context_with_inclusion, []) }

      let(:context_with_inclusion) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
          attribute_type: :input,
          attribute_name: :status,
          attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:status],
          i18n_root_key: "servactory"
        )
      end

      it "ignores :be_inclusion key and returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "when attribute has target dynamic option" do
      subject(:submatcher) { described_class.new(context_with_target, []) }

      let(:context_with_target) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
          attribute_type: :input,
          attribute_name: :options,
          attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:options],
          i18n_root_key: "servactory"
        )
      end

      it "ignores :be_target key and returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end
  end
end
