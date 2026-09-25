# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example21, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example21Child }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        id:,
        title:
      }
    end

    let(:id) { "0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64" }
    let(:title) { "Release" }

    it_behaves_like "check class info",
                    inputs: %i[id title],
                    internals: %i[],
                    outputs: %i[summary]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:summary)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds without input matching" do
        before do
          allow_service(child_service_class)
            .succeeds(summary: "Mocked summary")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:summary, "Mocked summary")
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
              .with_output(:summary, "Release (0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64)")
          )
        end

        it "records the call with the Datory object" do
          perform

          expect(child_service_class).to have_received(:call).with(an_instance_of(child_service_class::Event))
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Summary unavailable")
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Summary unavailable")
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
        id:,
        title:
      }
    end

    let(:id) { "0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64" }
    let(:title) { "Release" }

    it_behaves_like "check class info",
                    inputs: %i[id title],
                    internals: %i[],
                    outputs: %i[summary]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:summary)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using legacy helper without input matching" do
        before do
          allow_service_as_success(child_service_class) do
            { summary: "Legacy summary" }
          end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:summary, "Legacy summary")
          )
        end
      end

      describe "when using and_wrap_original with positional arguments" do
        before do
          allow_service(child_service_class)
            .and_wrap_original do |original, *arguments|
              result = original.call(*arguments)
              Servactory::TestKit::Result.as_success(
                service_class: child_service_class,
                summary: "Wrapped #{result.summary}"
              )
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:summary, "Wrapped Release (0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64)")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails without input matching" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Summary unavailable")
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Summary unavailable",
            meta: nil
          )
        end
      end
    end
  end

  describe "default input matching of the child service mock" do
    let(:event) do
      child_service_class::Event.deserialize(id: "0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64", title: "Release")
    end

    shared_examples "matches a Datory object" do |method_name|
      it "matches a Datory object passed positionally" do
        expect { child_service_class.public_send(method_name, event) }.not_to raise_error
      end

      it "rejects a Datory object together with other arguments" do
        expect { child_service_class.public_send(method_name, event, { title: "Other" }) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
        )
      end
    end

    context "when using succeeds" do
      before do
        allow_service(child_service_class).succeeds(summary: "Mocked summary")
      end

      it_behaves_like "matches a Datory object", :call
    end

    context "when using succeeds for call!" do
      before do
        allow_service!(child_service_class).succeeds(summary: "Mocked summary")
      end

      it_behaves_like "matches a Datory object", :call!
    end

    context "when using fails" do
      before do
        allow_service(child_service_class).fails(type: :base, message: "Summary unavailable")
      end

      it_behaves_like "matches a Datory object", :call
    end

    context "when using and_call_original" do
      before do
        allow_service(child_service_class).and_call_original
      end

      it_behaves_like "matches a Datory object", :call
    end

    context "when using and_call_original for call!" do
      before do
        allow_service!(child_service_class).and_call_original
      end

      it_behaves_like "matches a Datory object", :call!
    end

    context "when using and_wrap_original with positional arguments for call!" do
      before do
        allow_service!(child_service_class).and_wrap_original do |original, *arguments|
          original.call(*arguments)
        end
      end

      it_behaves_like "matches a Datory object", :call!
    end

    context "when using legacy helper" do
      before do
        allow_service_as_success(child_service_class) { { summary: "Legacy summary" } }
      end

      it_behaves_like "matches a Datory object", :call
    end
  end
end
