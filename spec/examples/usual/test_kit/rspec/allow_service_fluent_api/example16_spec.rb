# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example16, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example16Child }

  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[greeting]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds without input matching" do
        before do
          allow_service(child_service_class)
            .succeeds(greeting: "hi")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:greeting, "HI")
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
              .with_output(:greeting, "HELLO-EN")
          )
        end

        it "records the call without arguments" do
          perform

          expect(child_service_class).to have_received(:call).with(no_args)
        end
      end

      describe "when using and_wrap_original without input matching" do
        before do
          allow_service(child_service_class)
            .and_wrap_original do |original, **inputs|
              original.call(**inputs, locale: "de")
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:greeting, "HELLO-DE")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Greeting failed")
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Greeting failed")
              expect(exception.meta).to be_nil
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[greeting]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds without input matching" do
        before do
          allow_service(child_service_class)
            .succeeds(greeting: "hi")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:greeting, "HI")
          )
        end
      end

      describe "when using legacy helper without input matching" do
        before do
          allow_service_as_success(child_service_class) do
            { greeting: "hi" }
          end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:greeting, "HI")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Greeting failed")
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Greeting failed",
            meta: nil
          )
        end
      end
    end
  end

  describe "default input matching of the child service mock" do
    shared_examples "matches calls without required inputs" do |method_name|
      it "matches a call without arguments" do
        expect { child_service_class.public_send(method_name) }.not_to raise_error
      end

      it "matches a call with an empty Hash" do
        expect { child_service_class.public_send(method_name, {}) }.not_to raise_error
      end

      it "matches a call with the optional input" do
        expect { child_service_class.public_send(method_name, locale: "de") }.not_to raise_error
      end

      it "rejects a call with an unknown input" do
        expect { child_service_class.public_send(method_name, page: 2) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end

      it "describes the optional inputs in the failure message" do
        expect { child_service_class.public_send(method_name, page: 2) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /expected: \(service_inputs\(required: \[\], optional: \[:locale\]\)\)/
        )
      end
    end

    context "when using succeeds" do
      before do
        allow_service(child_service_class).succeeds(greeting: "hi")
      end

      it_behaves_like "matches calls without required inputs", :call
    end

    context "when using succeeds for call!" do
      before do
        allow_service!(child_service_class).succeeds(greeting: "hi")
      end

      it_behaves_like "matches calls without required inputs", :call!
    end

    context "when using fails" do
      before do
        allow_service(child_service_class).fails(type: :base, message: "Greeting failed")
      end

      it_behaves_like "matches calls without required inputs", :call
    end

    context "when using fails for call!" do
      before do
        allow_service!(child_service_class).fails(type: :base, message: "Greeting failed")
      end

      it "raises the configured failure for a call without arguments" do
        expect { child_service_class.call! }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Greeting failed"
        )
      end

      it "raises the configured failure for a call with an empty Hash" do
        expect { child_service_class.call!({}) }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Greeting failed"
        )
      end

      it "rejects a call with an unknown input" do
        expect { child_service_class.call!(page: 2) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :call! with unexpected arguments/
        )
      end
    end

    context "when using and_call_original" do
      before do
        allow_service(child_service_class).and_call_original
      end

      it_behaves_like "matches calls without required inputs", :call
    end

    context "when using and_call_original for call!" do
      before do
        allow_service!(child_service_class).and_call_original
      end

      it_behaves_like "matches calls without required inputs", :call!
    end

    context "when using and_wrap_original" do
      before do
        allow_service(child_service_class).and_wrap_original do |original, **inputs|
          original.call(**inputs)
        end
      end

      it_behaves_like "matches calls without required inputs", :call
    end

    context "when using and_wrap_original for call!" do
      before do
        allow_service!(child_service_class).and_wrap_original do |original, **inputs|
          original.call(**inputs)
        end
      end

      it_behaves_like "matches calls without required inputs", :call!
    end

    context "when using legacy helper" do
      before do
        allow_service_as_success(child_service_class) { { greeting: "hi" } }
      end

      it_behaves_like "matches calls without required inputs", :call
    end

    context "when using legacy helper for call!" do
      before do
        allow_service_as_success!(child_service_class) { { greeting: "hi" } }
      end

      it_behaves_like "matches calls without required inputs", :call!
    end
  end

  describe "sequential responses of the child service mock" do
    context "when mocking call" do
      before do
        allow_service(child_service_class)
          .succeeds(greeting: "first")
          .then_succeeds(greeting: "second")
      end

      it "returns sequential results for calls without arguments" do
        greetings = Array.new(3) { child_service_class.call.greeting }

        expect(greetings).to eq(%w[first second second])
      end

      it "does not advance the sequence on a rejected call", :aggregate_failures do
        expect { child_service_class.call(page: 2) }.to raise_error(RSpec::Mocks::MockExpectationError)
        expect(child_service_class.call.greeting).to eq("first")
      end

      it "counts calls without arguments" do
        2.times { child_service_class.call }

        expect(child_service_class).to have_received(:call).twice
      end
    end

    context "when mocking call!" do
      before do
        allow_service!(child_service_class)
          .succeeds(greeting: "first")
          .then_fails(type: :base, message: "Greeting failed")
      end

      it "returns sequential results for calls without arguments", :aggregate_failures do
        expect(child_service_class.call!.greeting).to eq("first")
        expect { child_service_class.call! }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Greeting failed"
        )
      end

      it "does not advance the sequence on a rejected call", :aggregate_failures do
        expect { child_service_class.call!(page: 2) }.to raise_error(RSpec::Mocks::MockExpectationError)
        expect(child_service_class.call!.greeting).to eq("first")
      end
    end
  end
end
