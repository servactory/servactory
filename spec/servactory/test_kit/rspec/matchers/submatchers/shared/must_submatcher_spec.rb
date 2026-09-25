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

      it "shows the expected and the actual rules", :aggregate_failures do
        submatcher.matches?(nil)

        expect(submatcher.failure_message).to include("expected must rules: be_even")
        expect(submatcher.failure_message).to include("got must rules: be_positive")
      end
    end

    context "when expected is superset of actual" do
      subject(:submatcher) { described_class.new(context, %i[be_positive be_even]) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "when attribute has no must rules" do
      subject(:submatcher) { described_class.new(context_without_must, [:be_positive]) }

      let(:context_without_must) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
          attribute_type: :input,
          attribute_name: :name,
          attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:name],
          i18n_root_key: "servactory"
        )
      end

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end

      it "shows that the attribute has no must rules", :aggregate_failures do
        submatcher.matches?(nil)

        expect(submatcher.failure_message).to include("expected must rules: be_positive")
        expect(submatcher.failure_message).to include("got must rules: (empty)")
      end

      it "fails the attribute matcher" do
        matcher = Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher
                  .new(Usual::TestKit::Rspec::Matchers::MinimalInputService, :name)
                  .must(:be_positive)

        expect(matcher.matches?(nil)).to be(false)
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

  describe ".arguments_from" do
    it "returns bare names without messages" do
      expect(described_class.arguments_from([%i[be_positive be_even]])).to eq([%i[be_positive be_even], {}])
    end

    it "splits a trailing Hash of messages" do
      expect(described_class.arguments_from([:be_positive, { be_even: "Must be even" }])).to eq(
        [[:be_positive], { be_even: "Must be even" }]
      )
    end

    it "returns messages without bare names" do
      expect(described_class.arguments_from([{ be_even: /even/ }])).to eq([[], { be_even: /even/ }])
    end
  end

  describe "rule messages" do
    let(:service_class) { Usual::TestKit::Rspec::Matchers::MessagesService }
    let(:attribute_data) { service_class.info.inputs.fetch(:number) }

    def build_submatcher(names, messages, attribute_type: :input, attribute_name: :number, data: attribute_data)
      context = Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
        described_class: service_class,
        attribute_type:,
        attribute_name:,
        attribute_data: data
      )

      described_class.new(context, names, messages)
    end

    def default_message_for(code)
      "[Usual::TestKit::Rspec::Matchers::MessagesService] Input `number` must \"#{code}\""
    end

    it "counts the keys of messages as rule names" do
      submatcher = build_submatcher([], { be_even: "Number must be even", be_positive: :default, be_small: /small/ })

      expect(submatcher.matches?(nil)).to be(true)
    end

    it "fails when a rule is listed neither by name nor by key" do
      submatcher = build_submatcher([:be_positive], { be_even: "Number must be even" })

      expect(submatcher.matches?(nil)).to be(false)
    end

    it "describes the expected messages" do
      submatcher = build_submatcher([:be_positive], { be_even: "Number must be even", be_small: /small/ })

      expect(submatcher.description).to eq(
        'must: be_positive, be_even with message "Number must be even", be_small with message /small/'
      )
    end

    it "raises ArgumentError for an expected message of another kind" do
      expect { build_submatcher([], { be_even: 1 }) }.to raise_error(ArgumentError, /got 1\z/)
    end

    context "with a String message" do
      it "passes when the message is equal" do
        submatcher = build_submatcher(%i[be_positive be_small], { be_even: "Number must be even" })

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "fails when the message differs only in case" do
        submatcher = build_submatcher(%i[be_positive be_small], { be_even: "number must be even" })

        expect(submatcher.matches?(nil)).to be(false)
      end

      it "shows the rule, the expected and the actual message", :aggregate_failures do
        submatcher = build_submatcher(%i[be_positive be_small], { be_even: "Number must be odd" })
        submatcher.matches?(nil)

        expect(submatcher.failure_message).to include("should return expected message for must rule `be_even`")
        expect(submatcher.failure_message).to include('expected "Number must be odd"')
        expect(submatcher.failure_message).to include('got "Number must be even"')
      end
    end

    context "with a Regexp message" do
      it "passes when the Regexp matches" do
        submatcher = build_submatcher(%i[be_positive be_small], { be_even: /must be even\z/ })

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "fails when the Regexp does not match" do
        submatcher = build_submatcher(%i[be_positive be_small], { be_even: /odd/ })

        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "with a rule without a custom message" do
      it "compares a String with the default message" do
        submatcher = build_submatcher(%i[be_even be_small], { be_positive: default_message_for(:be_positive) })

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "uses the same default message as the service" do
        expect { service_class.call!(status: :active, kind: :primary, number: -2) }.to raise_error(
          ApplicationService::Exceptions::Input,
          default_message_for(:be_positive)
        )
      end

      it "fails for another String" do
        submatcher = build_submatcher(%i[be_even be_small], { be_positive: "Number must be positive" })

        expect(submatcher.matches?(nil)).to be(false)
      end

      it "passes for :default" do
        submatcher = build_submatcher(%i[be_even be_small], { be_positive: :default })

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "applies an RSpec matcher to the missing message" do
        submatcher = build_submatcher(%i[be_even be_small], { be_positive: be_nil })

        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "with :default for a rule with a custom message" do
      it "fails" do
        submatcher = build_submatcher(%i[be_positive be_small], { be_even: :default })

        expect(submatcher.matches?(nil)).to be(false)
      end
    end

    context "with a Proc message" do
      it "passes the rule name and the attribute" do
        submatcher = build_submatcher(%i[be_even be_positive], { be_small: "Input `number` must be_small" })

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "applies an RSpec matcher to the Proc" do
        submatcher = build_submatcher(%i[be_even be_positive], { be_small: be_a(Proc) })

        expect(submatcher.matches?(nil)).to be(true)
      end

      it "passes every keyword the library passes" do
        data = attribute_data.merge(
          must: attribute_data.fetch(:must).merge(
            be_small: {
              is: ->(value:, **) { value < 100 },
              message: lambda do |service:, input:, value:, code:, reason:, meta:|
                "#{service.class_name}: #{input.name} #{code} #{[value, reason, meta].inspect}"
              end
            }
          )
        )

        submatcher = build_submatcher(
          %i[be_even be_positive],
          { be_small: "Usual::TestKit::Rspec::Matchers::MessagesService: number be_small [nil, nil, nil]" },
          data:
        )

        expect(submatcher.matches?(nil)).to be(true)
      end

      context "when the Proc does not accept every keyword the library passes" do
        subject(:submatcher) do
          build_submatcher(%i[be_even be_positive], { be_small: "Input `number` is too big" }, data:)
        end

        let(:data) do
          attribute_data.merge(
            must: attribute_data.fetch(:must).merge(
              be_small: {
                is: ->(value:, **) { value < 100 },
                message: ->(input:) { "Input `#{input.name}` is too big" }
              }
            )
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "describes the error in the failure message", :aggregate_failures do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include(
            'could not build the Proc message to compare with "Input `number` is too big"'
          )
          expect(submatcher.failure_message).to include("ArgumentError:")
        end
      end

      context "when the Proc raises with a value known only at validation time" do
        subject(:submatcher) do
          build_submatcher(%i[be_even be_positive], { be_small: "Input `number` is 100" }, data:)
        end

        let(:data) do
          attribute_data.merge(
            must: attribute_data.fetch(:must).merge(
              be_small: {
                is: ->(value:, **) { value < 100 },
                message: ->(value:, **) { "Input `number` is #{value.abs}" }
              }
            )
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end
      end
    end

    context "with an internal attribute" do
      it "passes the internal attribute to a Proc message" do
        submatcher = build_submatcher(
          [],
          { be_positive: "Internal attribute `count` must be positive" },
          attribute_type: :internal,
          attribute_name: :count,
          data: service_class.info.internals.fetch(:count)
        )

        expect(submatcher.matches?(nil)).to be(true)
      end
    end
  end

  describe "rules generated by option helpers" do
    let(:service_class) { Usual::TestKit::Rspec::Matchers::OptionHelperRulesService }

    def build_submatcher(attribute_name, names, messages, attribute_type: :input)
      context = Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
        described_class: service_class,
        attribute_type:,
        attribute_name:,
        attribute_data: service_class.info.public_send(:"#{attribute_type}s").fetch(attribute_name)
      )

      described_class.new(context, names, messages)
    end

    it "may be listed by name" do
      submatcher = build_submatcher(:age, %i[be_greater_than_or_equal_to be_less_than_or_equal_to], {})

      expect(submatcher.matches?(nil)).to be(true)
    end

    it "must still be listed" do
      submatcher = build_submatcher(:email, [:be_corporate], {})

      expect(submatcher.matches?(nil)).to be(false)
    end

    it "allows messages of other rules" do
      submatcher = build_submatcher(:email, [:be_in_format], { be_corporate: "Email must be corporate" })

      expect(submatcher.matches?(nil)).to be(true)
    end

    it "explains that the message depends on the validated value" do
      expect { build_submatcher(:email, [:be_corporate], { be_in_format: "Email is invalid" }) }.to raise_error(
        ArgumentError,
        "The message of must rule `be_in_format` cannot be checked: an option helper generated the rule, " \
        "and its message depends on the validated value. List the rule by name, as in " \
        "`must(:be_in_format)`, and check the error message with `raise_error`."
      )
    end

    {
      "min" => [:age, :be_greater_than_or_equal_to, [:be_less_than_or_equal_to]],
      "max" => [:age, :be_less_than_or_equal_to, [:be_greater_than_or_equal_to]],
      "multiple_of" => [:quantity, :be_multiple_of, []],
      "a custom DynamicOptions::Must subclass" => [:code, :be_custom_eq, []],
      "a helper with a Proc equivalent" => [:title, :be_short, []],
      "a helper with a Hash equivalent" => [:invoice_numbers, :be_6_characters, []]
    }.each do |helper, (attribute_name, rule_name, other_names)|
      it "raises ArgumentError for a rule of #{helper}" do
        expect { build_submatcher(attribute_name, other_names, { rule_name => :default }) }.to raise_error(
          ArgumentError,
          /The message of must rule `#{rule_name}` cannot be checked/
        )
      end
    end

    it "raises ArgumentError for a rule of target with a custom name" do
      expect { build_submatcher(:handler, [], { be_expect: /String/ }, attribute_type: :internal) }.to raise_error(
        ArgumentError,
        /The message of must rule `be_expect` cannot be checked/
      )
    end

    it "does not confuse a rule of the service with a rule of a helper with the same name" do
      context = Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
        described_class: Usual::Must::Example1,
        attribute_type: :input,
        attribute_name: :invoice_numbers,
        attribute_data: Usual::Must::Example1.info.inputs.fetch(:invoice_numbers)
      )

      submatcher = described_class.new(context, [], { be_6_characters: "Wrong IDs in `invoice_numbers`" })

      expect(submatcher.matches?(nil)).to be(true)
    end
  end
end
