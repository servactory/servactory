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

    it "includes the expected message" do
      expect(submatcher.description).to eq('message: "Config schema validation failed"')
    end

    context "when the expected message is a matcher" do
      subject(:submatcher) { described_class.new(context, be_a(String)) }

      it "includes the description of the matcher" do
        expect(submatcher.description).to eq("message: be a kind of String")
      end
    end
  end

  describe "#matches?" do
    def submatcher_context(**options)
      Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(described_class: service_class, **options)
    end

    def build_submatcher(expected_message, attribute_name:, option:, attribute_type: :input, attribute_data: nil)
      attribute_data ||= service_class.info.public_send(:"#{attribute_type}s").fetch(attribute_name)
      context_options = { attribute_type:, attribute_name:, attribute_data: }
      option_submatcher_class, *option_arguments = option
      last_submatcher = option_submatcher_class.new(submatcher_context(**context_options), *option_arguments)

      described_class.new(submatcher_context(**context_options, last_submatcher:), expected_message)
    end

    context "when message matches exactly" do
      it "returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end

      it "leaves missing_option empty" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).to eq("")
      end
    end

    context "when message differs only in case" do
      subject(:submatcher) { described_class.new(context, "CONFIG SCHEMA VALIDATION FAILED") }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "when message is a part of the actual message" do
      subject(:submatcher) { described_class.new(context, "Config schema") }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "when a Regexp matches the message" do
      subject(:submatcher) { described_class.new(context, /schema validation/) }

      it "returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "when a Regexp does not match the message" do
      subject(:submatcher) { described_class.new(context, /\Aschema/) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end

      it "shows the Regexp and the actual message in the failure message", :aggregate_failures do
        submatcher.matches?(nil)

        expect(submatcher.failure_message).to include("expected /\\Aschema/")
        expect(submatcher.failure_message).to include('got "Config schema validation failed"')
      end
    end

    context "when an RSpec matcher matches the message" do
      subject(:submatcher) { described_class.new(context, a_string_starting_with("Config")) }

      it "returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "when an RSpec matcher does not match the message" do
      subject(:submatcher) { described_class.new(context, be_a(Proc)) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end

      it "shows the matcher and the actual message in the failure message", :aggregate_failures do
        submatcher.matches?(nil)

        expect(submatcher.failure_message).to include("expected be a kind of Proc")
        expect(submatcher.failure_message).to include('got "Config schema validation failed"')
      end
    end

    context "when message doesn't match" do
      subject(:submatcher) { described_class.new(context, "Wrong message") }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end

      it "sets missing_option with failure message" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).not_to be_empty
      end
    end

    context "when expected message is nil" do
      subject(:submatcher) { described_class.new(context, nil) }

      it "returns true (nil message skips validation)" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "when expected message is empty" do
      subject(:submatcher) { described_class.new(context, "") }

      it "returns true (empty message skips validation)" do
        expect(submatcher.matches?(nil)).to be(true)
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
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "with types submatcher" do
      let(:service_class) { Usual::TestKit::Rspec::Matchers::CustomMessageService }
      let(:types_submatcher_class) { Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::TypesSubmatcher }

      it "returns true when the input type message matches" do
        submatcher = build_submatcher(
          "Count must be an Integer",
          attribute_name: :count,
          option: [types_submatcher_class, [Integer]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "returns true when the internal type message matches" do
        submatcher = build_submatcher(
          "Total must be a number",
          attribute_type: :internal,
          attribute_name: :total,
          option: [types_submatcher_class, [Integer, Float]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "returns false when the type message does not match" do
        submatcher = build_submatcher(
          "Wrong message",
          attribute_name: :count,
          option: [types_submatcher_class, [Integer]]
        )

        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "with target submatcher" do
      let(:service_class) { Usual::DynamicOptions::Target::Example4 }
      let(:target_submatcher_class) { Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::TargetSubmatcher }

      it "returns true when the target message matches" do
        submatcher = build_submatcher(
          "Custom error",
          attribute_name: :service_class,
          option: [target_submatcher_class, :target, [service_class::TargetA]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "returns false when the target message does not match" do
        submatcher = build_submatcher(
          "Wrong message",
          attribute_name: :service_class,
          option: [target_submatcher_class, :target, [service_class::TargetA]]
        )

        expect(submatcher.matches?(nil)).to be(false)
      end

      it "passes the option name and value to a Proc message" do
        attribute_data = service_class.info.inputs.fetch(:service_class).merge(
          target: {
            in: service_class::TargetA,
            message: ->(option_name:, option_value:, **) { "#{option_name}: #{option_value.name}" }
          }
        )

        submatcher = build_submatcher(
          "target: Usual::DynamicOptions::Target::Example4::TargetA",
          attribute_name: :service_class,
          attribute_data:,
          option: [target_submatcher_class, :target, [service_class::TargetA]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      context "when the target option has a custom name" do
        let(:service_class) { Usual::DynamicOptions::Target::Example8 }

        it "returns true when the target message matches" do
          submatcher = build_submatcher(
            "Internal custom error",
            attribute_type: :internal,
            attribute_name: :service_class,
            option: [target_submatcher_class, :expect, [service_class::TargetA, service_class::TargetB]]
          )

          expect(submatcher.matches?(nil)).to be(true)
        end
      end
    end

    context "with a Proc message" do
      let(:shared) { Servactory::TestKit::Rspec::Matchers::Submatchers::Shared }
      let(:service_class) { Usual::TestKit::Rspec::Matchers::ProcMessageService }

      it "passes the actor, the option value and a nil value" do
        submatcher = build_submatcher(
          "Input `status` must be one of [:active, :inactive], got nil",
          attribute_name: :status,
          option: [shared::InclusionSubmatcher, %i[active inactive]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "returns false when the built message does not match" do
        submatcher = build_submatcher(
          "Input `status` is wrong",
          attribute_name: :status,
          option: [shared::InclusionSubmatcher, %i[active inactive]]
        )

        expect(submatcher.matches?(nil)).to be(false)
      end

      it "passes the service" do
        submatcher = build_submatcher(
          "[Usual::TestKit::Rspec::Matchers::ProcMessageService] Input `ids` must contain Integer values",
          attribute_name: :ids,
          option: [shared::ConsistsOfSubmatcher, [Integer]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "passes nil for a keyword known only at validation time" do
        submatcher = build_submatcher(
          "Input `config` is invalid",
          attribute_name: :config,
          option: [shared::SchemaSubmatcher, { key: { type: String } }]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "passes only the accepted keywords" do
        attribute_data = service_class.info.inputs.fetch(:status).merge(
          inclusion: {
            in: %i[active inactive],
            message: ->(input:, option_value:, reason: "none") { "#{input.name}: #{option_value} (#{reason})" }
          }
        )

        submatcher = build_submatcher(
          "status: [:active, :inactive] (none)",
          attribute_name: :status,
          attribute_data:,
          option: [shared::InclusionSubmatcher, %i[active inactive]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "matches a Regexp against the built message" do
        submatcher = build_submatcher(
          /must be one of \[:active, :inactive\]/,
          attribute_name: :status,
          option: [shared::InclusionSubmatcher, %i[active inactive]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "compares the built message exactly" do
        submatcher = build_submatcher(
          "input `status` must be one of [:active, :inactive], got nil",
          attribute_name: :status,
          option: [shared::InclusionSubmatcher, %i[active inactive]]
        )

        expect(submatcher.matches?(nil)).to be(false)
      end

      it "applies an RSpec matcher to the Proc" do
        submatcher = build_submatcher(
          be_a(Proc),
          attribute_name: :status,
          option: [shared::InclusionSubmatcher, %i[active inactive]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "passes the expected types for the type option" do
        submatcher = build_submatcher(
          "Input `count` must be Integer, Float",
          attribute_name: :count,
          option: [shared::TypesSubmatcher, [Integer, Float]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "passes the internal actor" do
        submatcher = build_submatcher(
          "Internal attribute `tags` must contain String values",
          attribute_type: :internal,
          attribute_name: :tags,
          option: [shared::ConsistsOfSubmatcher, [String]]
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      context "when the Proc raises with a value known only at validation time" do
        subject(:submatcher) do
          build_submatcher(
            "Input `status` got ACTIVE",
            attribute_name: :status,
            attribute_data:,
            option: [shared::InclusionSubmatcher, %i[active inactive]]
          )
        end

        let(:attribute_data) do
          service_class.info.inputs.fetch(:status).merge(
            inclusion: {
              in: %i[active inactive],
              message: ->(input:, value:, **) { "Input `#{input.name}` got #{value.upcase}" }
            }
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "describes the error in the failure message", :aggregate_failures do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include(
            'could not build the Proc message to compare with "Input `status` got ACTIVE"'
          )
          expect(submatcher.failure_message).to include("NoMethodError:")
          expect(submatcher.failure_message).to match(/undefined method .upcase. for nil/)
        end
      end

      context "when the Proc returns nil for a value known only at validation time" do
        subject(:submatcher) do
          build_submatcher(
            "Input `status` is invalid",
            attribute_name: :status,
            attribute_data:,
            option: [shared::InclusionSubmatcher, %i[active inactive]]
          )
        end

        let(:attribute_data) do
          service_class.info.inputs.fetch(:status).merge(
            inclusion: {
              in: %i[active inactive],
              message: ->(value:, **) { { active: "Input `status` is invalid" }[value] }
            }
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "shows the returned value in the failure message" do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include("got nil, which is not a String")
        end
      end

      context "when the Proc returns a Symbol" do
        subject(:submatcher) do
          build_submatcher(
            /invalid/,
            attribute_name: :status,
            attribute_data:,
            option: [shared::InclusionSubmatcher, %i[active inactive]]
          )
        end

        let(:attribute_data) do
          service_class.info.inputs.fetch(:status).merge(
            inclusion: {
              in: %i[active inactive],
              message: ->(**) { :invalid }
            }
          )
        end

        it "does not match a Regexp" do
          expect(submatcher.matches?(nil)).to be(false)
        end
      end

      context "when the Proc raises ArgumentError" do
        subject(:submatcher) do
          build_submatcher(
            "Input `status` is invalid",
            attribute_name: :status,
            attribute_data:,
            option: [shared::InclusionSubmatcher, %i[active inactive]]
          )
        end

        let(:attribute_data) do
          service_class.info.inputs.fetch(:status).merge(
            inclusion: {
              in: %i[active inactive],
              message: ->(input) { "Input `#{input.name}` is invalid" }
            }
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "describes the error in the failure message" do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include("ArgumentError: wrong number of arguments")
        end
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject(:submatcher) { described_class.new(context, "Wrong message") }

      before { submatcher.matches?(nil) }

      it "includes expected message" do
        expect(submatcher.failure_message).to include('expected "Wrong message"')
      end

      it "includes actual message" do
        expect(submatcher.failure_message).to include('got "Config schema validation failed"')
      end
    end

    context "when the message built by a Proc does not match" do
      subject(:submatcher) do
        described_class.new(
          Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
            described_class: service_class,
            attribute_type: :input,
            attribute_name: :ids,
            attribute_data: service_class.info.inputs.fetch(:ids),
            last_submatcher: consists_of_submatcher
          ),
          "Wrong message"
        )
      end

      let(:service_class) { Usual::TestKit::Rspec::Matchers::ProcMessageService }

      let(:consists_of_submatcher) do
        Servactory::TestKit::Rspec::Matchers::Submatchers::Shared::ConsistsOfSubmatcher.new(
          Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
            described_class: service_class,
            attribute_type: :input,
            attribute_name: :ids,
            attribute_data: service_class.info.inputs.fetch(:ids)
          ),
          [Integer]
        )
      end

      before { submatcher.matches?(nil) }

      it "shows the expected message and the built message", :aggregate_failures do
        expect(submatcher.failure_message).to include('expected "Wrong message"')
        expect(submatcher.failure_message).to include(
          'got "[Usual::TestKit::Rspec::Matchers::ProcMessageService] Input `ids` must contain Integer values"'
        )
      end
    end
  end
end
