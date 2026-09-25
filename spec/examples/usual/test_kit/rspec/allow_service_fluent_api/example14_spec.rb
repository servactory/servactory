# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example14, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example14Child }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        text:
      }
    end

    let(:text) { "hello" }

    it_behaves_like "check class info",
                    inputs: %i[text],
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
      describe "when using and_wrap_original for a call with a positional Hash" do
        before do
          allow_service!(child_service_class)
            .and_wrap_original do |original, **inputs|
              result = original.call(**inputs, suffix: "?")
              Servactory::TestKit::Result.as_success(
                service_class: child_service_class,
                result: "wrapped:#{result.result}"
              )
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "wrapped:hello?")
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        text:
      }
    end

    let(:text) { "hello" }

    it_behaves_like "check class info",
                    inputs: %i[text],
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
      describe "when using and_wrap_original for a call with a positional Hash" do
        before do
          allow_service!(child_service_class)
            .and_wrap_original do |original, **inputs|
              original.call(**inputs)
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:result, "hello!")
          )
        end
      end
    end
  end

  describe "block arguments of and_wrap_original" do
    let(:call_inputs) { { text: "hello" } }
    let(:received_inputs) { [] }

    shared_examples "passes inputs as keywords" do |method_name|
      it "passes inputs of a keyword call as keywords" do
        child_service_class.public_send(method_name, **call_inputs)

        expect(received_inputs).to eq([call_inputs])
      end

      it "passes inputs of a positional Hash call as keywords" do
        child_service_class.public_send(method_name, call_inputs)

        expect(received_inputs).to eq([call_inputs])
      end

      it "delegates a keyword call to the original" do
        expect(child_service_class.public_send(method_name, **call_inputs)).to(
          be_success_service
            .with_output(:result, "hello!")
        )
      end

      it "delegates a positional Hash call to the original" do
        expect(child_service_class.public_send(method_name, call_inputs)).to(
          be_success_service
            .with_output(:result, "hello!")
        )
      end
    end

    context "when mocking call" do
      before do
        allow_service(child_service_class)
          .and_wrap_original do |original, **inputs|
            received_inputs << inputs
            original.call(**inputs)
          end
      end

      it_behaves_like "passes inputs as keywords", :call
    end

    context "when mocking call!" do
      before do
        allow_service!(child_service_class)
          .and_wrap_original do |original, **inputs|
            received_inputs << inputs
            original.call(**inputs)
          end
      end

      it_behaves_like "passes inputs as keywords", :call!
    end

    context "when the block takes positional arguments" do
      before do
        allow_service(child_service_class)
          .and_wrap_original do |original, *arguments|
            received_inputs.concat(arguments)
            original.call(*arguments)
          end
      end

      it "passes inputs of a keyword call as a Hash" do
        child_service_class.call(**call_inputs)

        expect(received_inputs).to eq([call_inputs])
      end

      it "passes inputs of a positional Hash call as a Hash" do
        child_service_class.call(call_inputs)

        expect(received_inputs).to eq([call_inputs])
      end

      it "delegates to the original" do
        expect(child_service_class.call(call_inputs)).to(
          be_success_service
            .with_output(:result, "hello!")
        )
      end
    end
  end

  describe "and_wrap_original without a block" do
    it "raises ArgumentError for call" do
      expect { allow_service(child_service_class).and_wrap_original }.to raise_error(
        ArgumentError,
        /Cannot call and_wrap_original\(\) without a block/
      )
    end

    it "raises ArgumentError for call!" do
      expect { allow_service!(child_service_class).and_wrap_original }.to raise_error(
        ArgumentError,
        /Cannot call and_wrap_original\(\) without a block/
      )
    end
  end
end
