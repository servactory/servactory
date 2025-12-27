# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Base::Submatcher do
  subject { concrete_submatcher_class.new(context) }

  let(:concrete_submatcher_class) do
    Class.new(described_class) do
      def description
        "test submatcher"
      end

      protected

      def passes?
        true
      end

      def build_failure_message
        "test failure"
      end
    end
  end

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

  describe "#matches?" do
    context "when passes? returns true" do
      it "returns true" do
        expect(subject.matches?(nil)).to be true
      end

      it "does not set missing_option" do
        subject.matches?(nil)
        expect(subject.missing_option).to eq("")
      end
    end

    context "when passes? returns false" do
      subject { failing_submatcher_class.new(context) }

      let(:failing_submatcher_class) do
        Class.new(described_class) do
          def description
            "failing submatcher"
          end

          protected

          def passes?
            false
          end

          def build_failure_message
            "test failure message"
          end
        end
      end

      it "returns false" do
        expect(subject.matches?(nil)).to be false
      end

      it "sets missing_option from build_failure_message" do
        subject.matches?(nil)
        expect(subject.missing_option).to eq("test failure message")
      end
    end
  end

  describe "#failure_message" do
    it "returns missing_option value" do
      expect(subject.failure_message).to eq("")
    end

    context "after failed match" do
      subject { failing_submatcher_class.new(context) }

      let(:failing_submatcher_class) do
        Class.new(described_class) do
          def description
            "failing submatcher"
          end

          protected

          def passes?
            false
          end

          def build_failure_message
            "specific failure"
          end
        end
      end

      it "returns the failure message" do
        subject.matches?(nil)
        expect(subject.failure_message).to eq("specific failure")
      end
    end
  end

  describe "#failure_message_when_negated" do
    it "includes description" do
      expect(subject.failure_message_when_negated).to eq("expected not to test submatcher")
    end
  end

  describe "abstract method enforcement" do
    subject { incomplete_submatcher_class.new(context) }

    let(:incomplete_submatcher_class) do
      Class.new(described_class)
    end

    it "raises NotImplementedError for #description" do
      expect { subject.description }.to raise_error(NotImplementedError, /must implement #description/)
    end

    it "raises NotImplementedError for #passes?" do
      expect { subject.send(:passes?) }.to raise_error(NotImplementedError, /must implement #passes\?/)
    end

    it "raises NotImplementedError for #build_failure_message" do
      expect do
        subject.send(:build_failure_message)
      end.to raise_error(NotImplementedError, /must implement #build_failure_message/)
    end
  end

  describe "RSpec::Matchers::Composable inclusion" do
    it "includes RSpec::Matchers::Composable" do
      expect(described_class.included_modules).to include(RSpec::Matchers::Composable)
    end
  end
end
