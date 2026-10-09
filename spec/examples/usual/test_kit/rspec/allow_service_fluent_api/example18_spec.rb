# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example18, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example18Child }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        query:
      }
    end

    let(:query) { "ruby" }

    it_behaves_like "check class info",
                    inputs: %i[query],
                    internals: %i[],
                    outputs: %i[matches_count]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:matches_count)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds without input matching" do
        before do
          allow_service(child_service_class)
            .succeeds(matches: %w[first second])
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:matches_count, 2)
          )
        end
      end

      describe "when using and_call_original without input matching" do
        before do
          allow_service(child_service_class)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:matches_count, 3)
          )
        end
      end

      describe "when using and_wrap_original with named keywords" do
        before do
          allow_service(child_service_class)
            .and_wrap_original do |original, query:, **inputs|
              original.call(**inputs, query:, limit: query.length)
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:matches_count, 4)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Search failed")
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Search failed")
              expect(exception.meta).to be_nil
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        query:
      }
    end

    let(:query) { "ruby" }

    it_behaves_like "check class info",
                    inputs: %i[query],
                    internals: %i[],
                    outputs: %i[matches_count]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:matches_count)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds without input matching" do
        before do
          allow_service(child_service_class)
            .succeeds(matches: %w[first])
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:matches_count, 1)
          )
        end
      end

      describe "when using legacy helper without input matching" do
        before do
          allow_service_as_success(child_service_class) do
            { matches: %w[first second] }
          end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:matches_count, 2)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Search failed")
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Search failed",
            meta: nil
          )
        end
      end
    end
  end

  describe "default input matching of the child service mock" do
    let(:string_key_inputs) { { "query" => "ruby", "limit" => 5 } }
    let(:indifferent_inputs) { ActiveSupport::HashWithIndifferentAccess.new(query: "ruby") }

    shared_examples "matches inputs with normalized keys" do |method_name|
      it "matches String keys passed as a positional Hash" do
        expect { child_service_class.public_send(method_name, string_key_inputs) }.not_to raise_error
      end

      it "matches String keys passed as keywords" do
        expect { child_service_class.public_send(method_name, **string_key_inputs) }.not_to raise_error
      end

      it "matches HashWithIndifferentAccess passed as a positional Hash" do
        expect { child_service_class.public_send(method_name, indifferent_inputs) }.not_to raise_error
      end

      it "matches HashWithIndifferentAccess passed as keywords" do
        expect { child_service_class.public_send(method_name, **indifferent_inputs) }.not_to raise_error
      end

      it "rejects String keys without the required input" do
        expect { child_service_class.public_send(method_name, { "limit" => 5 }) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end

      it "rejects an unknown String key" do
        expect { child_service_class.public_send(method_name, { "query" => "ruby", "page" => 2 }) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end

      it "rejects HashWithIndifferentAccess with an unknown input" do
        indifferent_inputs[:page] = 2

        expect { child_service_class.public_send(method_name, indifferent_inputs) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end
    end

    context "when using succeeds" do
      before do
        allow_service(child_service_class).succeeds(matches: %w[first])
      end

      it_behaves_like "matches inputs with normalized keys", :call
    end

    context "when using succeeds for call!" do
      before do
        allow_service!(child_service_class).succeeds(matches: %w[first])
      end

      it_behaves_like "matches inputs with normalized keys", :call!
    end

    context "when using fails" do
      before do
        allow_service(child_service_class).fails(type: :base, message: "Search failed")
      end

      it_behaves_like "matches inputs with normalized keys", :call
    end

    context "when using and_call_original" do
      before do
        allow_service(child_service_class).and_call_original
      end

      it_behaves_like "matches inputs with normalized keys", :call
    end

    context "when using and_call_original for call!" do
      before do
        allow_service!(child_service_class).and_call_original
      end

      it_behaves_like "matches inputs with normalized keys", :call!
    end

    context "when using legacy helper" do
      before do
        allow_service_as_success(child_service_class) { { matches: %w[first] } }
      end

      it_behaves_like "matches inputs with normalized keys", :call
    end

    context "when a mock without input matching follows a mock with it" do
      before do
        allow_service(child_service_class).with(hash_including(query: "ruby")).succeeds(matches: %w[matched])
        allow_service(child_service_class).succeeds(matches: %w[default])
      end

      it "handles calls matching the earlier mock" do
        expect(child_service_class.call(query: "ruby")).to(
          be_success_service
            .with_output(:matches, %w[default])
        )
      end

      it "rejects invalid inputs instead of deferring to the earlier mock" do
        expect { child_service_class.call(query: "ruby", page: 2) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :call with unexpected arguments/
        )
      end
    end

    context "when a mock with input matching follows a mock without it" do
      before do
        allow_service(child_service_class).succeeds(matches: %w[default])
        allow_service(child_service_class).with(query: "ruby").succeeds(matches: %w[matched])
      end

      it "handles calls matching the later mock with it" do
        expect(child_service_class.call(query: "ruby")).to(
          be_success_service
            .with_output(:matches, %w[matched])
        )
      end

      it "handles other calls with the earlier mock" do
        expect(child_service_class.call(query: "rails")).to(
          be_success_service
            .with_output(:matches, %w[default])
        )
      end
    end
  end

  describe "block arguments of and_wrap_original" do
    let(:received_arguments) { [] }
    let(:indifferent_inputs) { ActiveSupport::HashWithIndifferentAccess.new(query: "ruby") }

    shared_examples "passes inputs with String keys" do |method_name|
      context "when the block takes keywords" do
        before do
          builder.and_wrap_original do |original, **inputs|
            received_arguments << inputs
            original.call(**inputs)
          end
        end

        it "passes String keys of a positional Hash as Symbol keywords" do
          child_service_class.public_send(method_name, { "query" => "ruby", "limit" => 1 })

          expect(received_arguments).to eq([{ query: "ruby", limit: 1 }])
        end

        it "passes String keys given as keywords as Symbol keywords" do
          child_service_class.public_send(method_name, **{ "query" => "ruby" })

          expect(received_arguments).to eq([{ query: "ruby" }])
        end

        it "passes HashWithIndifferentAccess as Symbol keywords" do
          child_service_class.public_send(method_name, indifferent_inputs)

          expect(received_arguments).to eq([{ query: "ruby" }])
        end

        it "delegates HashWithIndifferentAccess to the original" do
          expect(child_service_class.public_send(method_name, indifferent_inputs)).to(
            be_success_service
              .with_output(:matches, %w[ruby-0 ruby-1 ruby-2])
          )
        end
      end

      context "when the block is a lambda with a named keyword" do
        before do
          wrap_block = lambda do |original, query:, **inputs|
            received_arguments << query
            original.call(**inputs, query:)
          end

          builder.and_wrap_original(&wrap_block)
        end

        it "passes the keyword from String keys of a positional Hash" do
          child_service_class.public_send(method_name, { "query" => "ruby" })

          expect(received_arguments).to eq(["ruby"])
        end

        it "passes the keyword from HashWithIndifferentAccess" do
          child_service_class.public_send(method_name, indifferent_inputs)

          expect(received_arguments).to eq(["ruby"])
        end
      end

      context "when the block takes positional arguments" do
        before do
          builder.and_wrap_original do |original, *arguments|
            received_arguments << arguments
            original.call(*arguments)
          end
        end

        it "passes String keys of a positional Hash as given" do
          child_service_class.public_send(method_name, { "query" => "ruby" })

          expect(received_arguments).to eq([[{ "query" => "ruby" }]])
        end

        it "passes HashWithIndifferentAccess as given" do
          child_service_class.public_send(method_name, indifferent_inputs)

          expect(received_arguments.first.first).to be(indifferent_inputs)
        end
      end
    end

    context "when mocking call" do
      let(:builder) { allow_service(child_service_class) }

      it_behaves_like "passes inputs with String keys", :call
    end

    context "when mocking call!" do
      let(:builder) { allow_service!(child_service_class) }

      it_behaves_like "passes inputs with String keys", :call!
    end
  end
end
