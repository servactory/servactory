# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Submatchers::Input::RequiredSubmatcher do
  subject(:submatcher) { described_class.new(required_context) }

  let(:required_context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :email,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:email],
      i18n_root_key: "servactory"
    )
  end

  let(:optional_context) do
    Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
      described_class: Usual::TestKit::Rspec::Matchers::MinimalInputService,
      attribute_type: :input,
      attribute_name: :age,
      attribute_data: Usual::TestKit::Rspec::Matchers::MinimalInputService.info.inputs[:age],
      i18n_root_key: "servactory"
    )
  end

  it_behaves_like "a submatcher"

  describe "#description" do
    it "includes 'required'" do
      expect(submatcher.description).to include("required")
    end

    it "indicates true" do
      expect(submatcher.description).to include("true")
    end
  end

  describe "#matches?" do
    context "when input is required" do
      it "returns true" do
        expect(submatcher.matches?(nil)).to be(true)
      end

      it "leaves missing_option empty" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).to eq("")
      end
    end

    context "when input is optional" do
      subject(:submatcher) { described_class.new(optional_context) }

      it "returns false" do
        expect(submatcher.matches?(nil)).to be(false)
      end

      it "sets missing_option with failure message" do
        submatcher.matches?(nil)
        expect(submatcher.missing_option).not_to be_empty
      end
    end

    context "without custom message" do
      it "passes when required is true" do
        expect(submatcher.matches?(nil)).to be(true)
      end
    end

    context "with an expected message" do
      subject(:submatcher) { described_class.new(required_context, expected_message) }

      context "when the default message matches" do
        let(:expected_message) do
          "[Usual::TestKit::Rspec::Matchers::MinimalInputService] Required input `email` is missing"
        end

        it "returns true" do
          expect(submatcher.matches?(nil)).to be(true)
        end
      end

      context "when the default message is expected" do
        let(:expected_message) { :default }

        it "returns true for an input without a custom message" do
          expect(submatcher.matches?(nil)).to be(true)
        end
      end

      context "when the expected message is nil" do
        let(:expected_message) { nil }

        it "does not check the message" do
          expect(submatcher.matches?(nil)).to be(true)
        end
      end

      context "when the expected message is of another kind" do
        let(:expected_message) { 1 }

        it "raises ArgumentError" do
          expect { submatcher }.to raise_error(ArgumentError, /must be a String, a Regexp, an RSpec matcher/)
        end
      end

      context "when the default message differs only in case" do
        let(:expected_message) do
          "[usual::testkit::rspec::matchers::minimalinputservice] required input `email` is missing"
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end
      end

      context "when a Regexp matches the default message" do
        let(:expected_message) { /Required input `email`/ }

        it "returns true" do
          expect(submatcher.matches?(nil)).to be(true)
        end
      end

      context "when a Regexp does not match the default message" do
        let(:expected_message) { /is required/ }

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end
      end

      context "when the default message does not match" do
        let(:expected_message) { "Input `email` is missing" }

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "shows the expected and the actual message in the failure message", :aggregate_failures do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include('expected "Input `email` is missing"')
          expect(submatcher.failure_message).to include(
            'got "[Usual::TestKit::Rspec::Matchers::MinimalInputService] Required input `email` is missing"'
          )
        end
      end
    end

    context "with a Proc message" do
      subject(:submatcher) { described_class.new(proc_message_context, expected_message) }

      let(:service_class) { Usual::Basic::Example17 }
      let(:attribute_data) { service_class.info.inputs.fetch(:first_name) }
      let(:expected_message) { "[Usual::Basic::Example17] Input `first_name` is required, got nil" }

      let(:proc_message_context) do
        Servactory::TestKit::Rspec::Matchers::Base::SubmatcherContext.new(
          described_class: service_class,
          attribute_type: :input,
          attribute_name: :first_name,
          attribute_data:,
          i18n_root_key: "servactory"
        )
      end

      it "passes the service, the input and a nil value" do
        expect(submatcher.matches?(nil)).to be(true)
      end

      context "when a Regexp matches the built message" do
        let(:expected_message) { /is required, got nil\z/ }

        it "returns true" do
          expect(submatcher.matches?(nil)).to be(true)
        end
      end

      context "when the default message is expected" do
        let(:expected_message) { :default }

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "shows the custom message in the failure message" do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include("got the custom message #<Proc:")
        end
      end

      context "when an RSpec matcher is expected" do
        let(:expected_message) { be_a(Proc) }

        it "applies the matcher to the Proc" do
          expect(submatcher.matches?(nil)).to be(true)
        end
      end

      context "when an RSpec matcher does not match the Proc" do
        let(:expected_message) { a_string_including("is required") }

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end
      end

      context "when the built message does not match" do
        let(:expected_message) { "Input `first_name` is missing" }

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "shows the expected and the built message in the failure message", :aggregate_failures do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include('expected "Input `first_name` is missing"')
          expect(submatcher.failure_message).to include(
            'got "[Usual::Basic::Example17] Input `first_name` is required, got nil"'
          )
        end
      end

      context "when the Proc raises with a value known only at validation time" do
        let(:expected_message) { "Input `first_name` got NIL" }

        let(:attribute_data) do
          service_class.info.inputs.fetch(:first_name).merge(
            required: {
              is: true,
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
            'could not build the Proc message to compare with "Input `first_name` got NIL"'
          )
          expect(submatcher.failure_message).to include("NoMethodError:")
        end
      end

      context "when the Proc does not accept the keywords the library passes" do
        let(:expected_message) { "Input `first_name` is required" }

        let(:attribute_data) do
          service_class.info.inputs.fetch(:first_name).merge(
            required: {
              is: true,
              message: ->(input:) { "Input `#{input.name}` is required" }
            }
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "describes the error in the failure message" do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include("ArgumentError:")
        end
      end

      context "when the Proc returns nil for a value known only at validation time" do
        let(:expected_message) { "Input `first_name` is blank" }

        let(:attribute_data) do
          service_class.info.inputs.fetch(:first_name).merge(
            required: {
              is: true,
              message: ->(value:, **) { { "" => "Input `first_name` is blank" }[value] }
            }
          )
        end

        it "returns false" do
          expect(submatcher.matches?(nil)).to be(false)
        end

        it "shows the returned value in the failure message" do
          submatcher.matches?(nil)

          expect(submatcher.failure_message).to include("got nil")
        end
      end
    end
  end

  describe "#failure_message" do
    context "when match fails" do
      subject(:submatcher) { described_class.new(optional_context) }

      before { submatcher.matches?(nil) }

      it "indicates expected required state" do
        expect(submatcher.failure_message).to include("required: true")
      end

      it "indicates actual required state" do
        expect(submatcher.failure_message).to include("required: false")
      end
    end
  end
end
