# frozen_string_literal: true

RSpec.describe "Message checks in attribute matcher chains" do # rubocop:disable RSpec/DescribeClass
  let(:service_class) { Usual::TestKit::Rspec::Matchers::MessagesService }

  def input_matcher(name)
    Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(service_class, name)
  end

  def internal_matcher(name)
    Servactory::TestKit::Rspec::Matchers::HaveServiceInternalMatcher.new(service_class, name)
  end

  describe "several messages in one chain" do
    it "passes when every message matches" do
      matcher = input_matcher(:status)
                .type(Symbol).message("Status must be a Symbol")
                .inclusion(%i[active inactive]).message("Status must be active or inactive")

      expect(matcher.matches?(nil)).to be(true)
    end

    it "fails when an earlier message does not match" do
      matcher = input_matcher(:status)
                .type(Symbol).message("Wrong type message")
                .inclusion(%i[active inactive]).message("Status must be active or inactive")

      expect(matcher.matches?(nil)).to be(false)
    end

    it "shows the failing message in the failure message", :aggregate_failures do
      matcher = input_matcher(:status)
                .type(Symbol).message("Wrong type message")
                .inclusion(%i[active inactive]).message("Status must be active or inactive")

      matcher.matches?(nil)

      expect(matcher.failure_message).to include('expected "Wrong type message"')
      expect(matcher.failure_message).to include('got "Status must be a Symbol"')
    end

    it "fails when a later message does not match" do
      matcher = input_matcher(:status)
                .type(Symbol).message("Status must be a Symbol")
                .inclusion(%i[active inactive]).message("Wrong inclusion message")

      expect(matcher.matches?(nil)).to be(false)
    end

    it "checks every message chained after the same option" do
      matcher = input_matcher(:status)
                .type(Symbol).message(/Symbol/).message("Wrong type message")

      expect(matcher.matches?(nil)).to be(false)
    end

    it "describes every message" do
      matcher = input_matcher(:status)
                .type(Symbol).message("Status must be a Symbol")
                .inclusion(%i[active inactive]).message(/active/)

      expect(matcher.description).to eq(
        "status with type(s): Symbol, message: \"Status must be a Symbol\", " \
        "inclusion: active, inactive, message: /active/"
      )
    end

    it "checks every message of an internal attribute" do
      matcher = internal_matcher(:state)
                .type(Symbol).message("Wrong type message")
                .inclusion(%i[new done]).message("State must be new or done")

      expect(matcher.matches?(nil)).to be(false)
    end
  end

  describe "must rule messages" do
    it "passes for bare names mixed with expected messages" do
      matcher = input_matcher(:number).must(:be_positive, be_even: "Number must be even", be_small: /be_small\z/)

      expect(matcher.matches?(nil)).to be(true)
    end

    it "accepts an Array of bare names with expected messages" do
      matcher = input_matcher(:number).must(%i[be_positive be_small], be_even: "Number must be even")

      expect(matcher.matches?(nil)).to be(true)
    end

    it "fails when an expected message does not match" do
      matcher = input_matcher(:number).must(:be_positive, :be_small, be_even: "Number must be odd")

      expect(matcher.matches?(nil)).to be(false)
    end

    it "checks the messages of an internal attribute" do
      matcher = internal_matcher(:count).must(be_positive: "Internal attribute `count` must be negative")

      expect(matcher.matches?(nil)).to be(false)
    end

    it "keeps the expected messages along with other messages in the chain" do
      matcher = input_matcher(:number)
                .must(:be_positive, :be_small, be_even: "Number must be odd")
                .type(Integer).message(:default)

      expect(matcher.matches?(nil)).to be(false)
    end
  end

  describe "a message after must" do
    it "passes when the message of the rule matches" do
      matcher = internal_matcher(:count).must(:be_positive).message("Internal attribute `count` must be positive")

      expect(matcher.matches?(nil)).to be(true)
    end

    it "fails when the message of the rule does not match" do
      matcher = internal_matcher(:count).must(:be_positive).message(/negative/)

      expect(matcher.matches?(nil)).to be(false)
    end

    it "is the same as the keyed form" do
      sugar = internal_matcher(:count).must(:be_positive).message(/positive/)
      keyed = internal_matcher(:count).must(be_positive: /positive/)

      expect(sugar.description).to eq(keyed.description)
    end

    it "is kept along with later messages of other options" do
      matcher = internal_matcher(:count)
                .must(:be_positive).message(/negative/)
                .type(Integer).message(:default)

      expect(matcher.matches?(nil)).to be(false)
    end

    it "is removed with a must replaced later in the chain" do
      matcher = internal_matcher(:count).must(:be_positive).message(/negative/).must(:be_positive)

      expect(matcher.matches?(nil)).to be(true)
    end

    it "raises ArgumentError when must names several rules" do
      expect { input_matcher(:number).must(:be_even, :be_positive, :be_small).message("Number must be even") }
        .to raise_error(
          ArgumentError,
          "`message` after `must` needs exactly one rule, got 3. Use the keyed form to expect a message " \
          "for each rule, as in `must(be_even: ..., be_positive: ..., be_small: ...)`."
        )
    end

    it "raises ArgumentError when must names no rule" do
      expect { input_matcher(:number).must([]).message("Number must be even") }.to raise_error(
        ArgumentError,
        "`message` after `must` needs a rule name, e.g. `must(:rule).message(...)`."
      )
    end

    it "raises ArgumentError when the rule already has an expected message" do
      expect { internal_matcher(:count).must(be_positive: /positive/).message(:default) }.to raise_error(
        ArgumentError,
        "Rule `be_positive` already has an expected message"
      )
    end
  end

  describe "must rule messages of option helpers" do
    let(:service_class) { Usual::TestKit::Rspec::Matchers::OptionHelperRulesService }

    it "lists the rules by name" do
      matcher = input_matcher(:email).must(:be_in_format, be_corporate: "Email must be corporate")

      expect(matcher.matches?(nil)).to be(true)
    end

    it "raises ArgumentError for an expected message" do
      expect { input_matcher(:email).must(:be_corporate, be_in_format: /format/) }.to raise_error(
        ArgumentError,
        /check the error message with `raise_error`/
      )
    end

    it "raises ArgumentError for a message chained after must" do
      expect { input_matcher(:title).must(:be_short).message(/too long/) }.to raise_error(
        ArgumentError,
        /The message of must rule `be_short` cannot be checked/
      )
    end
  end

  describe "a message of a replaced option" do
    it "is removed with the option" do
      matcher = input_matcher(:status)
                .inclusion(%i[active inactive]).message("Wrong inclusion message")
                .inclusion(%i[active inactive])

      expect(matcher.matches?(nil)).to be(true)
    end

    it "does not remove messages of other options" do
      matcher = input_matcher(:status)
                .type(Symbol).message("Wrong type message")
                .inclusion(%i[active inactive]).message("Status must be active or inactive")
                .inclusion(%i[active inactive])

      expect(matcher.matches?(nil)).to be(false)
    end
  end

  describe "a message without an option with a message before it" do
    it "raises ArgumentError when it is first in the chain" do
      expect { input_matcher(:status).message("Status must be a Symbol") }.to raise_error(
        ArgumentError,
        /chain it after `type`, `consists_of`, `schema`, `inclusion`, `target` or `must`, not first in the chain/
      )
    end

    it "raises ArgumentError after an option without a message" do
      expect { input_matcher(:kind).optional.message("Kind is optional") }.to raise_error(
        ArgumentError,
        /not after `required: false`/
      )
    end

    it "suggests passing the required message to required" do
      expect { input_matcher(:kind).required.message("Kind is required") }.to raise_error(
        ArgumentError,
        /To check the required message, pass it to `required`/
      )
    end
  end
end
