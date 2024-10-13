# frozen_string_literal: true

RSpec.describe Usual::PredicateMethodsEnabled::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }

        # rubocop:disable Layout/LineLength
        it "returns expected error", :aggregate_failures do
          expect { perform.full_name? }.to raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:base)
            expect(exception.message).to(
              match(
                if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                  /\[Usual::PredicateMethodsEnabled::Example1\] undefined method 'full_name\?' for #<ApplicationService::Result/
                else
                  /\[Usual::PredicateMethodsEnabled::Example1\] undefined method `full_name\?' for #<ApplicationService::Result/
                end
              )
            )
            expect(exception.meta).to match(original_exception: be_a(NoMethodError))
          end
        end
        # rubocop:enable Layout/LineLength
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[first_name middle_name last_name],
                     internals: %i[],
                     outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:full_name).with("John Fitzgerald Kennedy") }

        # rubocop:disable Layout/LineLength
        it "returns expected error", :aggregate_failures do
          expect { perform.full_name? }.to raise_error do |exception|
            expect(exception).to be_a(ApplicationService::Exceptions::Failure)
            expect(exception.type).to eq(:base)
            expect(exception.message).to(
              match(
                if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                  /\[Usual::PredicateMethodsEnabled::Example1\] undefined method 'full_name\?' for #<ApplicationService::Result/
                else
                  /\[Usual::PredicateMethodsEnabled::Example1\] undefined method `full_name\?' for #<ApplicationService::Result/
                end
              )
            )
            expect(exception.meta).to match(original_exception: be_a(NoMethodError))
          end
        end
        # rubocop:enable Layout/LineLength
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end
  end
end
