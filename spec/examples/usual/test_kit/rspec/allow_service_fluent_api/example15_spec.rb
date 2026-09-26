# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example15, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example15Child }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        id:
      }
    end

    let(:id) { 7 }

    it_behaves_like "check class info",
                    inputs: %i[id],
                    internals: %i[],
                    outputs: %i[label]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:label)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using and_call_original for call!" do
        before do
          allow_service!(child_service_class)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:label, "item-7")
          )
        end

        it "records the call without the optional input" do
          perform

          expect(child_service_class).to have_received(:call!).with(id: 7)
        end
      end

      describe "when using and_call_original with input matching for call!" do
        before do
          allow_service!(child_service_class)
            .with(id: 7)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:label, "item-7")
          )
        end

        it "rejects inputs other than configured" do
          expect { child_service_class.call!(id: 8) }.to raise_error(
            RSpec::Mocks::MockExpectationError,
            /received :call! with unexpected arguments/
          )
        end
      end

      describe "when using and_wrap_original with input matching for call!" do
        before do
          allow_service!(child_service_class)
            .with(including(id: 7))
            .and_wrap_original do |original, **inputs|
              original.call(**inputs, prefix: "wrapped")
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:label, "wrapped-7")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the wrapped child service raises a failure" do
        before do
          allow_service!(child_service_class)
            .and_wrap_original do |_original, **inputs|
              raise ApplicationService::Exceptions::Failure.new(message: "Label #{inputs[:id]} is unavailable")
            end
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Label 7 is unavailable")
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
        id:
      }
    end

    let(:id) { 7 }

    it_behaves_like "check class info",
                    inputs: %i[id],
                    internals: %i[],
                    outputs: %i[label]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:label)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using and_call_original for call!" do
        before do
          allow_service!(child_service_class)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:label, "item-7")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the wrapped child service raises a failure" do
        before do
          allow_service!(child_service_class)
            .and_wrap_original do |_original, **inputs|
              raise ApplicationService::Exceptions::Failure.new(message: "Label #{inputs[:id]} is unavailable")
            end
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Label 7 is unavailable",
            meta: nil
          )
        end
      end
    end
  end

  describe "pass-through guard errors" do
    it "raises when then_fails is called after and_call_original" do
      expect do
        allow_service(child_service_class)
          .and_call_original
          .then_fails(message: "error")
      end.to raise_error(ArgumentError, /Cannot call then_fails\(\) after and_call_original\(\)/)
    end

    it "raises when then_succeeds is called after and_wrap_original" do
      expect do
        allow_service(child_service_class)
          .and_wrap_original { |original, **inputs| original.call(**inputs) }
          .then_succeeds(label: "value")
      end.to raise_error(ArgumentError, /Cannot call then_succeeds\(\) after and_wrap_original\(\)/)
    end

    it "raises when and_call_original is called after then_succeeds" do
      expect do
        allow_service(child_service_class)
          .succeeds(label: "first")
          .then_succeeds(label: "second")
          .and_call_original
      end.to raise_error(ArgumentError, %r{Cannot call and_call_original\(\) after then_succeeds/then_fails})
    end

    it "raises when and_wrap_original is called after then_fails" do
      expect do
        allow_service(child_service_class)
          .succeeds(label: "first")
          .then_fails(message: "error")
          .and_wrap_original { |original, **inputs| original.call(**inputs) }
      end.to raise_error(ArgumentError, %r{Cannot call and_wrap_original\(\) after then_succeeds/then_fails})
    end

    it "raises when and_wrap_original is called after and_call_original" do
      expect do
        allow_service(child_service_class)
          .and_call_original
          .and_wrap_original { |original, **inputs| original.call(**inputs) }
      end.to raise_error(ArgumentError, /Cannot call and_wrap_original\(\) after and_call_original\(\)/)
    end

    it "raises when and_call_original is called after and_wrap_original" do
      expect do
        allow_service(child_service_class)
          .and_wrap_original { |original, **inputs| original.call(**inputs) }
          .and_call_original
      end.to raise_error(ArgumentError, /Cannot call and_call_original\(\) after and_wrap_original\(\)/)
    end

    it "raises when fails is called after and_wrap_original" do
      expect do
        allow_service!(child_service_class)
          .and_wrap_original { |original, **inputs| original.call(**inputs) }
          .fails(message: "error")
      end.to raise_error(ArgumentError, /Cannot call fails\(\) after and_wrap_original\(\)/)
    end

    it "raises when and_wrap_original is called after fails" do
      expect do
        allow_service!(child_service_class)
          .fails(message: "error")
          .and_wrap_original { |original, **inputs| original.call(**inputs) }
      end.to raise_error(ArgumentError, /Cannot call and_wrap_original\(\) after fails\(\)/)
    end
  end
end
