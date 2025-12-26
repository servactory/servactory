# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext do
  subject do
    described_class.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :name,
      attribute_data: { types: [String] },
      option_types: [String],
      last_submatcher: nil,
      i18n_root_key: "servactory"
    )
  end

  describe "struct attributes" do
    it "provides access to described_class" do
      expect(subject.described_class).to eq(Usual::TestKit::Rspec::Matchers::MinimalInputService)
    end

    it "provides access to attribute_type" do
      expect(subject.attribute_type).to eq(:input)
    end

    it "provides access to attribute_name" do
      expect(subject.attribute_name).to eq(:name)
    end

    it "provides access to attribute_data" do
      expect(subject.attribute_data).to eq({ types: [String] })
    end

    it "provides access to option_types" do
      expect(subject.option_types).to eq([String])
    end

    it "provides access to last_submatcher" do
      expect(subject.last_submatcher).to be_nil
    end

    it "provides access to i18n_root_key" do
      expect(subject.i18n_root_key).to eq("servactory")
    end
  end

  describe "#attribute_type_plural" do
    it "pluralizes :input to :inputs" do
      expect(subject.attribute_type_plural).to eq(:inputs)
    end

    context "with :internal attribute_type" do
      subject do
        described_class.new(
          described_class: Usual::TestKit::Rspec::Matchers::MinimalInternalService,
          attribute_type: :internal,
          attribute_name: :processed,
          attribute_data: {},
          i18n_root_key: "servactory"
        )
      end

      it "pluralizes :internal to :internals" do
        expect(subject.attribute_type_plural).to eq(:internals)
      end
    end

    context "with :output attribute_type" do
      subject do
        described_class.new(
          described_class: Usual::TestKit::Rspec::Matchers::MinimalOutputService,
          attribute_type: :output,
          attribute_name: :result,
          attribute_data: {},
          i18n_root_key: "servactory"
        )
      end

      it "pluralizes :output to :outputs" do
        expect(subject.attribute_type_plural).to eq(:outputs)
      end
    end

    it "memoizes the result" do
      first_call = subject.attribute_type_plural
      second_call = subject.attribute_type_plural
      expect(first_call).to equal(second_call)
    end
  end

  describe "optional attributes" do
    it "allows nil option_types" do
      context = described_class.new(
        described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
        attribute_type: :input,
        attribute_name: :name,
        attribute_data: {},
        option_types: nil,
        i18n_root_key: "servactory"
      )
      expect(context.option_types).to be_nil
    end

    it "allows nil last_submatcher" do
      context = described_class.new(
        described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
        attribute_type: :input,
        attribute_name: :name,
        attribute_data: {},
        last_submatcher: nil,
        i18n_root_key: "servactory"
      )
      expect(context.last_submatcher).to be_nil
    end
  end

  describe "keyword_init" do
    it "is a Struct with keyword initialization" do
      expect(described_class.ancestors).to include(Struct)
    end
  end
end
