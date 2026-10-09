# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Concerns::RequiredMessage do
  subject(:host) { host_class.new(context) }

  let(:host_class) do
    Class.new(Servactory::TestKit::Rspec::Matchers::Base::Submatcher) do
      include Servactory::TestKit::Rspec::Matchers::Concerns::RequiredMessage

      def description
        "required message host"
      end
    end
  end

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: service_class,
      attribute_type: :input,
      attribute_name:,
      attribute_data: service_class.info.inputs.fetch(attribute_name),
      i18n_root_key: "servactory"
    )
  end

  context "without a custom message" do
    let(:service_class) { Usual::TestKit::Rspec::Matchers::MinimalInputService }
    let(:attribute_name) { :email }

    it "returns no custom message" do
      expect(host.required_custom_message).to be_nil
    end

    it "builds the default message" do
      expect(host.required_message).to eq(
        "[Usual::TestKit::Rspec::Matchers::MinimalInputService] Required input `email` is missing"
      )
    end
  end

  context "with a String message" do
    let(:service_class) { Usual::Basic::Example5 }
    let(:attribute_name) { :first_name }

    it "returns the custom message" do
      expect(host.required_message).to eq("Input `first_name` is required")
    end
  end

  context "with a Proc message" do
    let(:service_class) { Usual::Basic::Example17 }
    let(:attribute_name) { :first_name }

    it "returns the Proc as defined" do
      expect(host.required_custom_message).to be_a(Proc)
    end

    it "builds the message with a nil value" do
      expect(host.required_message).to eq("[Usual::Basic::Example17] Input `first_name` is required, got nil")
    end
  end
end
