# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example12, type: :service do
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
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child)
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
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:matches_count, 3)
          )
        end

        it "records the call without the optional input" do
          perform

          expect(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child).to(
            have_received(:call).with(query: "ruby")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child)
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
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child)
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
          allow_service_as_success(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child) do
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

      describe "when using and_call_original without input matching" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child)
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
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child)
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
    let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example12Child }

    shared_examples "matches declared inputs" do |method_name|
      it "matches when the optional input is omitted" do
        expect { child_service_class.public_send(method_name, query: "ruby") }.not_to raise_error
      end

      it "matches when all inputs are passed" do
        expect { child_service_class.public_send(method_name, query: "ruby", limit: 5) }.not_to raise_error
      end

      it "matches when inputs are passed as a positional Hash" do
        expect { child_service_class.public_send(method_name, { query: "ruby" }) }.not_to raise_error
      end

      it "rejects a call without the required input" do
        expect { child_service_class.public_send(method_name, limit: 5) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end

      it "rejects a call with an unknown input" do
        expect { child_service_class.public_send(method_name, query: "ruby", page: 2) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end

      it "describes required and optional inputs in the failure message" do
        expect { child_service_class.public_send(method_name, page: 2) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /expected: \(service_inputs\(required: \[:query\], optional: \[:limit\]\)\)/
        )
      end
    end

    context "when using succeeds" do
      before do
        allow_service(child_service_class).succeeds(matches: %w[first])
      end

      it_behaves_like "matches declared inputs", :call
    end

    context "when using succeeds for call!" do
      before do
        allow_service!(child_service_class).succeeds(matches: %w[first])
      end

      it_behaves_like "matches declared inputs", :call!
    end

    context "when using fails" do
      before do
        allow_service(child_service_class).fails(type: :base, message: "Search failed")
      end

      it_behaves_like "matches declared inputs", :call
    end

    context "when using and_call_original" do
      before do
        allow_service(child_service_class).and_call_original
      end

      it_behaves_like "matches declared inputs", :call
    end

    context "when using legacy helper" do
      before do
        allow_service_as_success(child_service_class) { { matches: %w[first] } }
      end

      it_behaves_like "matches declared inputs", :call
    end
  end
end
