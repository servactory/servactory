# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example20, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example20Child }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) { {} }

    it_behaves_like "check class info",
                    inputs: %i[separator],
                    internals: %i[],
                    outputs: %i[text]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:text)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using and_wrap_original with a keyword block" do
        before do
          allow_service!(child_service_class)
            .and_wrap_original do |original, **inputs|
              original.call(**inputs, separator: " & ")
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:text, "one & two")
          )
        end
      end

      describe "when using and_wrap_original with a positional block" do
        before do
          allow_service!(child_service_class)
            .and_wrap_original do |original, *arguments|
              original.call(*arguments)
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:text, "one, two")
          )
        end
      end

      describe "when the separator is passed" do
        let(:attributes) { { separator: " - " } }

        before do
          allow_service!(child_service_class)
            .and_wrap_original do |original, *arguments|
              original.call(*arguments)
            end
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:text, "one - two")
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service!(child_service_class)
            .fails(type: :base, message: "Text unavailable")
        end

        it "returns expected error" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Failure, "Text unavailable")
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) { {} }

    it_behaves_like "check class info",
                    inputs: %i[separator],
                    internals: %i[],
                    outputs: %i[text]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:text)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using and_wrap_original with a lambda" do
        before do
          wrap_block = lambda do |original, arguments|
            original.call(arguments.merge(separator: " + "))
          end

          allow_service!(child_service_class)
            .and_wrap_original(&wrap_block)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:text, "one + two")
          )
        end
      end
    end
  end

  describe "block arguments of and_wrap_original" do
    let(:received_arguments) { [] }

    shared_examples "passes the arguments of an empty Hash call" do |method_name|
      context "when the block takes keywords" do
        before do
          builder.and_wrap_original do |original, **inputs|
            received_arguments << inputs
            original.call(**inputs)
          end
        end

        it "passes no keywords for a call with an empty Hash" do
          child_service_class.public_send(method_name, {})

          expect(received_arguments).to eq([{}])
        end

        it "passes no keywords for a call without arguments" do
          child_service_class.public_send(method_name)

          expect(received_arguments).to eq([{}])
        end

        it "delegates a call with an empty Hash to the original" do
          expect(child_service_class.public_send(method_name, {})).to(
            be_success_service
              .with_output(:text, "one, two")
          )
        end
      end

      context "when the block takes positional arguments" do
        before do
          builder.and_wrap_original do |original, *arguments|
            received_arguments << arguments
            original.call(*arguments)
          end
        end

        it "passes the empty Hash of a call with an empty Hash" do
          child_service_class.public_send(method_name, {})

          expect(received_arguments).to eq([[{}]])
        end

        it "passes no arguments for a call without arguments" do
          child_service_class.public_send(method_name)

          expect(received_arguments).to eq([[]])
        end

        it "passes the inputs of a keyword call as a Hash" do
          child_service_class.public_send(method_name, separator: "-")

          expect(received_arguments).to eq([[{ separator: "-" }]])
        end

        it "delegates a call with an empty Hash to the original" do
          expect(child_service_class.public_send(method_name, {})).to(
            be_success_service
              .with_output(:text, "one, two")
          )
        end
      end

      context "when the block is a lambda with a positional parameter" do
        before do
          wrap_block = lambda do |original, arguments|
            received_arguments << arguments
            original.call(arguments)
          end

          builder.and_wrap_original(&wrap_block)
        end

        it "passes the empty Hash of a call with an empty Hash" do
          child_service_class.public_send(method_name, {})

          expect(received_arguments).to eq([{}])
        end

        it "passes the inputs of a keyword call as a Hash" do
          child_service_class.public_send(method_name, separator: "-")

          expect(received_arguments).to eq([{ separator: "-" }])
        end

        it "delegates a call with an empty Hash to the original" do
          expect(child_service_class.public_send(method_name, {})).to(
            be_success_service
              .with_output(:text, "one, two")
          )
        end
      end

      context "when the block is a lambda with keyword parameters" do
        before do
          wrap_block = lambda do |original, **inputs|
            received_arguments << inputs
            original.call(**inputs)
          end

          builder.and_wrap_original(&wrap_block)
        end

        it "passes no keywords for a call with an empty Hash" do
          child_service_class.public_send(method_name, {})

          expect(received_arguments).to eq([{}])
        end

        it "passes the inputs of a positional Hash call as keywords" do
          child_service_class.public_send(method_name, { separator: "-" })

          expect(received_arguments).to eq([{ separator: "-" }])
        end
      end
    end

    context "when mocking call" do
      let(:builder) { allow_service(child_service_class) }

      it_behaves_like "passes the arguments of an empty Hash call", :call
    end

    context "when mocking call!" do
      let(:builder) { allow_service!(child_service_class) }

      it_behaves_like "passes the arguments of an empty Hash call", :call!
    end
  end
end
