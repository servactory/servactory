# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Concerns::ProcMessage do
  subject(:host) { host_class.new(context) }

  let(:host_class) do
    Class.new(Servactory::TestKit::Rspec::Matchers::Base::Submatcher) do
      include Servactory::TestKit::Rspec::Matchers::Concerns::ProcMessage

      def description
        "proc message host"
      end
    end
  end

  let(:service_class) { Usual::TestKit::Rspec::Matchers::MessagesService }
  let(:attribute_type) { :input }
  let(:attribute_name) { :status }

  let(:context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: service_class,
      attribute_type:,
      attribute_name:,
      attribute_data: service_class.info.public_send(:"#{attribute_type}s").fetch(attribute_name),
      i18n_root_key: "servactory"
    )
  end

  describe "#proc_message_arguments" do
    {
      required: %i[input service value],
      type: %i[expected_type given_type input service value],
      must: %i[code input meta reason service value],
      dynamic_option: %i[code input option_name option_value reason service value],
      schema: %i[code expected_type given_type input key_name option_name option_value reason service value]
    }.each do |option, keywords|
      it "passes the keywords of the #{option} option" do
        expect(host.proc_message_arguments(option).keys).to match_array(keywords)
      end
    end

    it "passes the service information" do
      expect(host.proc_message_arguments(:required).fetch(:service).class_name).to eq(service_class.name)
    end

    it "passes the attribute" do
      expect(host.proc_message_arguments(:required).fetch(:input).name).to eq(:status)
    end

    it "passes nil for keywords without a given value" do
      expect(host.proc_message_arguments(:dynamic_option).except(:service, :input).values).to all(be_nil)
    end

    it "passes the given values" do
      arguments = host.proc_message_arguments(:dynamic_option, code: :be_inclusion, option_name: :inclusion)

      expect(arguments).to include(code: :be_inclusion, option_name: :inclusion, value: nil, reason: nil)
    end

    it "raises ArgumentError for a keyword the library does not pass" do
      expect { host.proc_message_arguments(:type, code: :be_inclusion) }.to raise_error(
        ArgumentError,
        "Unknown keywords for type messages: code"
      )
    end

    it "raises KeyError for an unknown option" do
      expect { host.proc_message_arguments(:unknown) }.to raise_error(KeyError)
    end

    context "with an internal attribute" do
      let(:attribute_type) { :internal }
      let(:attribute_name) { :state }

      it "passes the attribute as internal" do
        expect(host.proc_message_arguments(:type).keys).to contain_exactly(
          :service, :internal, :value, :expected_type, :given_type
        )
      end
    end
  end

  describe "#call_proc_message" do
    it "calls a Proc accepting every keyword" do
      message = ->(input:, value:, expected_type:, **) { "#{input.name} #{expected_type} #{value.inspect}" }

      expect(host.call_proc_message(message, :type, expected_type: "Symbol")).to eq("status Symbol nil")
    end

    it "raises for a Proc that does not accept every keyword" do
      message = ->(input:, expected_type:) { "#{input.name} #{expected_type}" }

      expect { host.call_proc_message(message, :type, expected_type: "Symbol") }.to raise_error(ArgumentError)
    end
  end
end
