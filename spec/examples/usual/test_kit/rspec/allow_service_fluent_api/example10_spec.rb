# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { "test" }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[],
                    outputs: %i[result]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:result)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using and_call_original" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "processed:test")
          )
        end
      end

      describe "when using and_call_original with input matching before" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .with(data: "test")
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "processed:test")
          )
        end
      end

      describe "when using and_call_original with input matching after" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .and_call_original
            .with(data: "test")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "processed:test")
          )
        end
      end

      describe "when using and_wrap_original" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .and_wrap_original do |original, **inputs|
              result = original.call(**inputs)
              Servactory::TestKit::Result.as_success(
                service_class: Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child,
                result: "wrapped:#{result.result}"
              )
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "wrapped:processed:test")
          )
        end
      end

      describe "when using and_wrap_original with input matching" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .and_wrap_original do |original, **inputs|
              result = original.call(**inputs)
              Servactory::TestKit::Result.as_success(
                service_class: Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child,
                result: "wrapped:#{result.result}"
              )
            end
            .with(data: "test")
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "wrapped:processed:test")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .fails(type: :base, message: "Processing failed")
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Processing failed")
              expect(exception.meta).to be_nil
            end
          )
        end
      end
    end

    describe "conflicting result type validation" do
      describe "raises error when succeeds is called after and_call_original" do
        it "raises ArgumentError with conflict message" do
          expect do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
              .and_call_original
              .succeeds(result: "value")
          end.to raise_error(
            ArgumentError,
            /Cannot call succeeds\(\) after and_call_original\(\)/
          )
        end
      end

      describe "raises error when and_call_original is called after succeeds" do
        it "raises ArgumentError with conflict message" do
          expect do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
              .succeeds(result: "value")
              .and_call_original
          end.to raise_error(
            ArgumentError,
            /Cannot call and_call_original\(\) after succeeds\(\)/
          )
        end
      end

      describe "raises error when then_succeeds is called after and_call_original" do
        it "raises ArgumentError with conflict message" do
          expect do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
              .and_call_original
              .then_succeeds(result: "value")
          end.to raise_error(
            ArgumentError,
            /Cannot call then_succeeds\(\) after and_call_original\(\)/
          )
        end
      end

      describe "raises error when then_fails is called after and_wrap_original" do
        it "raises ArgumentError with conflict message" do
          expect do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
              .and_wrap_original { |original, **inputs| original.call(**inputs) }
              .then_fails(message: "error")
          end.to raise_error(
            ArgumentError,
            /Cannot call then_fails\(\) after and_wrap_original\(\)/
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { "test" }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[],
                    outputs: %i[result]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:result)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using and_call_original" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "processed:test")
          )
        end
      end

      describe "when using and_wrap_original" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .and_wrap_original do |original, **inputs|
              result = original.call(**inputs)
              Servactory::TestKit::Result.as_success(
                service_class: Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child,
                result: "wrapped:#{result.result}"
              )
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "wrapped:processed:test")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example10Child)
            .fails(type: :base, message: "Processing failed")
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Processing failed",
            meta: nil
          )
        end
      end
    end
  end
end
