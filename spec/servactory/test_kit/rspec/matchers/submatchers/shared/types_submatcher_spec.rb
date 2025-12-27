# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::TypesSubmatcher do
  subject(:submatcher) { described_class.new(context, [String]) }

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :name,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:name],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes type name" do
      expect(submatcher.description).to include("String")
    end

    it "includes 'type' in description" do
      expect(submatcher.description).to match(/type/i)
    end

    context "with multiple types" do
      subject(:submatcher) { described_class.new(multi_context, [String, Hash, Array]) }

      let(:multi_context) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MultipleTypesService,
          attribute_type: :input,
          attribute_name: :data,
          attribute_data: Usual::TestKit::Rspec::Matchers::MultipleTypesService.info.inputs[:data],
          i18n_root_key: "servactory"
        )
      end

      it "includes all type names", :aggregate_failures do
        expect(submatcher.description).to include("String")
        expect(submatcher.description).to include("Hash")
        expect(submatcher.description).to include("Array")
      end
    end
  end

  describe "#matches?" do
    context "when types match exactly" do
      it "returns true" do
        expect(submatcher.matches?(nil)).to be true
      end

      it "leaves missing_option empty" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).to eq("")
      end
    end

    context "when types don't match" do
      subject(:submatcher) { described_class.new(context, [Integer]) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be false
      end

      it "sets missing_option with failure message" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).not_to be_empty
      end
    end

    context "when types match in different order" do
      subject(:submatcher) { described_class.new(multi_context, [Array, Hash, String]) }

      let(:multi_context) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MultipleTypesService,
          attribute_type: :input,
          attribute_name: :data,
          attribute_data: Usual::TestKit::Rspec::Matchers::MultipleTypesService.info.inputs[:data],
          i18n_root_key: "servactory"
        )
      end

      it "returns true (order independent)" do
        expect(submatcher.matches?(nil)).to be true
      end
    end

    context "when expected types is subset of actual" do
      subject(:submatcher) { described_class.new(multi_context, [String, Hash]) }

      let(:multi_context) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MultipleTypesService,
          attribute_type: :input,
          attribute_name: :data,
          attribute_data: Usual::TestKit::Rspec::Matchers::MultipleTypesService.info.inputs[:data],
          i18n_root_key: "servactory"
        )
      end

      it "returns false (missing Array)" do
        expect(submatcher.matches?(nil)).to be false
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject(:submatcher) { described_class.new(context, [Integer]) }

      before { submatcher.matches?(nil) }

      it "includes expected types" do
        expect(submatcher.failure_message).to include("Integer")
      end

      it "includes actual types" do
        expect(submatcher.failure_message).to include("String")
      end
    end
  end
end
