# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Matchers::Base::AttributeMatcher do
  subject { matcher }

  let(:described_service) { Usual::TestKit::Rspec::Matchers::MinimalInputService }

  let(:matcher) do
    Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
      described_service,
      :name
    )
  end

  it_behaves_like "an attribute matcher"

  describe ".for_attribute_type" do
    it "sets attribute_type for input matcher" do
      expect(Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.attribute_type).to eq(:input)
    end

    it "sets attribute_type for internal matcher" do
      expect(Servactory::TestKit::Rspec::Matchers::HaveServiceInternalMatcher.attribute_type).to eq(:internal)
    end
  end

  describe "#initialize" do
    it "stores described_class" do
      expect(matcher.described_class).to eq(described_service)
    end

    it "stores attribute_name" do
      expect(matcher.attribute_name).to eq(:name)
    end

    it "initializes with empty submatchers" do
      expect(matcher.send(:submatchers)).to eq([])
    end

    it "initializes option_types as nil" do
      expect(matcher.option_types).to be_nil
    end
  end

  describe "#supports_block_expectations?" do
    it "returns true" do
      expect(matcher.supports_block_expectations?).to be(true)
    end
  end

  describe "#matches?" do
    context "with no submatchers" do
      it "returns true" do
        expect(matcher.matches?(nil)).to be(true)
      end
    end

    context "with passing submatcher" do
      it "returns true" do
        matcher.type(String)
        expect(matcher.matches?(nil)).to be(true)
      end
    end

    context "with failing submatcher" do
      it "returns false" do
        matcher.type(Integer)
        expect(matcher.matches?(nil)).to be(false)
      end
    end

    context "with multiple submatchers" do
      context "when all pass" do
        it "returns true" do
          matcher.type(String)
          expect(matcher.matches?(nil)).to be(true)
        end
      end

      context "when any fails" do
        it "returns false" do
          # name is String and required, but we test with Integer
          matcher.type(Integer)
          expect(matcher.matches?(nil)).to be(false)
        end
      end
    end
  end

  describe "#description" do
    it "includes attribute name" do
      matcher.type(String)
      expect(matcher.description).to include("name")
    end

    it "includes submatcher descriptions" do
      matcher.type(String)
      description = matcher.description
      expect(description).to include("String")
    end

    context "with multiple submatchers" do
      let(:email_matcher) do
        Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :email
        )
      end

      it "includes all submatcher descriptions", :aggregate_failures do
        email_matcher.type(String).required
        expect(email_matcher.description).to include("String")
        expect(email_matcher.description).to include("required")
      end
    end
  end

  describe "#failure_message" do
    it "describes the expectation", :aggregate_failures do
      matcher.type(Integer)
      matcher.matches?(nil)

      expect(matcher.failure_message).to include(described_service.name)
      expect(matcher.failure_message).to include("input")
      expect(matcher.failure_message).to include("name")
    end
  end

  describe "#failure_message_when_negated" do
    it "describes the expectation" do
      expect(matcher.failure_message_when_negated).to include("Did not expect")
    end
  end

  describe "chain methods" do
    describe "#type / #types" do
      it "accepts single type" do
        expect(matcher.type(String)).to eq(matcher)
      end

      it "stores option_types" do
        matcher.type(String)
        # option_types is wrapped in array for submatcher compatibility
        expect(matcher.option_types).to eq([[String]])
      end

      context "with multiple types" do
        let(:multi_matcher) do
          Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
            Usual::TestKit::Rspec::Matchers::MultipleTypesService,
            :data
          )
        end

        it "accepts multiple types via types alias" do
          expect(multi_matcher.types(String, Hash, Array)).to eq(multi_matcher)
        end

        it "stores all types in option_types" do
          multi_matcher.types(String, Hash, Array)
          # option_types is wrapped in array for submatcher compatibility
          expect(multi_matcher.option_types).to eq([[String, Hash, Array]])
        end
      end
    end

    describe "#required" do
      let(:email_matcher) do
        Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :email
        )
      end

      it "adds required submatcher" do
        expect(email_matcher.required).to eq(email_matcher)
      end

      it "passes for required input" do
        email_matcher.required
        expect(email_matcher.matches?(nil)).to be(true)
      end
    end

    describe "#optional" do
      let(:age_matcher) do
        Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :age
        )
      end

      it "adds optional submatcher" do
        expect(age_matcher.optional).to eq(age_matcher)
      end

      it "passes for optional input" do
        age_matcher.optional
        expect(age_matcher.matches?(nil)).to be(true)
      end
    end

    describe "#default" do
      let(:age_matcher) do
        Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :age
        )
      end

      it "accepts default value" do
        expect(age_matcher.default(18)).to eq(age_matcher)
      end

      it "passes when default matches" do
        age_matcher.default(18)
        expect(age_matcher.matches?(nil)).to be(true)
      end

      it "fails when default doesn't match" do
        age_matcher.default(21)
        expect(age_matcher.matches?(nil)).to be(false)
      end
    end

    describe "#consists_of" do
      let(:tags_matcher) do
        Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :tags
        )
      end

      it "accepts consists_of type" do
        tags_matcher.type(Array)
        expect(tags_matcher.consists_of(String)).to eq(tags_matcher)
      end
    end

    describe "#inclusion" do
      let(:status_matcher) do
        Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :status
        )
      end

      it "accepts inclusion values" do
        expect(status_matcher.inclusion(%i[active inactive])).to eq(status_matcher)
      end
    end

    describe "mutual exclusivity" do
      it "removes required when optional is added", :aggregate_failures do
        matcher.required.optional

        expect(matcher.send(:submatchers).map { |s| s.class.name })
          .to include("Servactory::TestKit::Rspec::Matchers::Submatchers::Input::OptionalSubmatcher")
        expect(matcher.send(:submatchers).map { |s| s.class.name })
          .not_to include("Servactory::TestKit::Rspec::Matchers::Submatchers::Input::RequiredSubmatcher")
      end

      it "removes optional when required is added", :aggregate_failures do
        age_matcher = Servactory::TestKit::Rspec::Matchers::HaveServiceInputMatcher.new(
          described_service,
          :age
        )

        age_matcher.optional.required

        expect(age_matcher.send(:submatchers).map { |s| s.class.name })
          .to include("Servactory::TestKit::Rspec::Matchers::Submatchers::Input::RequiredSubmatcher")
        expect(age_matcher.send(:submatchers).map { |s| s.class.name })
          .not_to include("Servactory::TestKit::Rspec::Matchers::Submatchers::Input::OptionalSubmatcher")
      end
    end
  end

  describe "RSpec::Matchers::Composable inclusion" do
    it "includes RSpec::Matchers::Composable" do
      expect(described_class.included_modules).to include(RSpec::Matchers::Composable)
    end
  end
end
