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
        /chain it after `type`, `consists_of`, `schema`, `inclusion` or `target`, not first in the chain/
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
