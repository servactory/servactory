# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::MessageSubmatcher do
  # Use the actual submatcher classes to avoid constant definition issues
  subject(:submatcher) { described_class.new(context, "Config schema validation failed") }

  let(:schema_context_for_mock) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::CustomMessageService,
      attribute_type: :input,
      attribute_name: :config,
      attribute_data: Usual::TestKit::Rspec::Matchers::CustomMessageService.info.inputs[:config],
      i18n_root_key: "servactory"
    )
  end

  let(:schema_submatcher_instance) do
    Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::SchemaSubmatcher.new(
      schema_context_for_mock,
      { key: { type: String } }
    )
  end

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::CustomMessageService,
      attribute_type: :input,
      attribute_name: :config,
      attribute_data: Usual::TestKit::Rspec::Matchers::CustomMessageService.info.inputs[:config],
      last_submatcher: schema_submatcher_instance,
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'message'" do
      expect(submatcher.description).to include("message")
    end
  end

  describe "#matches?" do
    context "when message matches exactly" do
      it "returns true" do
        expect(submatcher.matches?(nil)).to be true
      end

      it "leaves missing_option empty" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).to eq("")
      end
    end

    context "when message matches case-insensitively" do
      subject(:submatcher) { described_class.new(context, "CONFIG SCHEMA VALIDATION FAILED") }

      it "returns true" do
        expect(submatcher.matches?(nil)).to be true
      end
    end

    context "when message doesn't match" do
      subject(:submatcher) { described_class.new(context, "Wrong message") }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be false
      end

      it "sets missing_option with failure message" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).not_to be_empty
      end
    end

    context "when expected message is nil" do
      subject(:submatcher) { described_class.new(context, nil) }

      it "returns true (nil message skips validation)" do
        expect(submatcher.matches?(nil)).to be true
      end
    end

    context "when expected message is empty" do
      subject(:submatcher) { described_class.new(context, "") }

      it "returns true (empty message skips validation)" do
        expect(submatcher.matches?(nil)).to be true
      end
    end

    context "with inclusion submatcher" do
      subject(:submatcher) { described_class.new(inclusion_context, "Status must be active or inactive") }

      let(:inclusion_context_for_mock) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::CustomMessageService,
          attribute_type: :input,
          attribute_name: :status,
          attribute_data: Usual::TestKit::Rspec::Matchers::CustomMessageService.info.inputs[:status],
          i18n_root_key: "servactory"
        )
      end

      let(:inclusion_submatcher_instance) do
        Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::InclusionSubmatcher.new(
          inclusion_context_for_mock,
          %i[active inactive]
        )
      end

      let(:inclusion_context) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::CustomMessageService,
          attribute_type: :input,
          attribute_name: :status,
          attribute_data: Usual::TestKit::Rspec::Matchers::CustomMessageService.info.inputs[:status],
          last_submatcher: inclusion_submatcher_instance,
          i18n_root_key: "servactory"
        )
      end

      it "returns true when message matches" do
        expect(submatcher.matches?(nil)).to be true
      end
    end

    # NOTE: Proc message testing is skipped because:
    # Procs with arguments (like ->(input:, value:)) require runtime context
    # that cannot be easily provided in unit tests. This behavior is covered
    # in integration tests where the full service context is available.
  end

  describe "#failure_message" do
    context "when match fails" do
      subject(:submatcher) { described_class.new(context, "Wrong message") }

      before { submatcher.matches?(nil) }

      it "includes expected message" do
        expect(submatcher.failure_message).to include("Wrong message")
      end

      it "includes actual message" do
        expect(submatcher.failure_message).to include("Config schema validation failed")
      end
    end
  end
end
