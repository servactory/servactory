# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Helpers::WrapBlockAdapter do
  describe ".adapt" do
    subject(:delegate) { described_class.adapt(wrap_block) }

    let(:original) { instance_double(Method) }

    context "when the block takes positional arguments" do
      let(:wrap_block) { proc { |_original, *arguments| arguments } }

      it "returns the block itself" do
        expect(delegate).to be(wrap_block)
      end

      it "passes String keys as given" do
        expect(delegate.call(original, { "user_id" => 1 })).to eq([{ "user_id" => 1 }])
      end

      it "passes HashWithIndifferentAccess as given" do
        inputs = ActiveSupport::HashWithIndifferentAccess.new(user_id: 1)

        expect(delegate.call(original, inputs).first).to be(inputs)
      end
    end

    context "when the block declares no keywords" do
      let(:wrap_block) { proc { |_original, *arguments, **nil| arguments } }

      it "returns the block itself" do
        expect(delegate).to be(wrap_block)
      end
    end

    context "when the block takes a keyword splat" do
      let(:wrap_block) { proc { |_original, *arguments, **inputs| [arguments, inputs] } }

      it "passes a positional Hash as keywords" do
        expect(delegate.call(original, { user_id: 1 })).to eq([[], { user_id: 1 }])
      end

      it "passes an empty positional Hash as no keywords" do
        expect(delegate.call(original, {})).to eq([[], {}])
      end

      it "passes no arguments as no keywords" do
        expect(delegate.call(original)).to eq([[], {}])
      end

      it "passes other arguments positionally" do
        expect(delegate.call(original, :first, :second)).to eq([%i[first second], {}])
      end

      it "passes String keys as Symbol keywords" do
        expect(delegate.call(original, { "user_id" => 1 })).to eq([[], { user_id: 1 }])
      end

      it "passes HashWithIndifferentAccess as Symbol keywords" do
        inputs = ActiveSupport::HashWithIndifferentAccess.new(user_id: 1)

        expect(delegate.call(original, inputs)).to eq([[], { user_id: 1 }])
      end

      it "passes a Datory object as Symbol keywords" do
        event = Usual::Datory::Example1::Event.deserialize(id: "0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64")

        expect(delegate.call(original, event)).to eq([[], { id: "0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64" }])
      end
    end

    context "when the block takes keywords and a block" do
      let(:wrap_block) { proc { |received_original, **, &block| [received_original, block.call] } }

      it "passes the original and the block through" do
        expect(delegate.call(original, {}) { :from_block }).to eq([original, :from_block])
      end
    end

    context "when the block takes a required keyword" do
      let(:wrap_block) { ->(_original, user_id:) { user_id } }

      it "passes a positional Hash as keywords" do
        expect(delegate.call(original, { user_id: 1 })).to eq(1)
      end

      it "passes the keyword from String keys" do
        expect(delegate.call(original, { "user_id" => 1 })).to eq(1)
      end

      it "passes the keyword from HashWithIndifferentAccess" do
        expect(delegate.call(original, ActiveSupport::HashWithIndifferentAccess.new(user_id: 1))).to eq(1)
      end
    end

    context "when the block takes an optional keyword" do
      let(:wrap_block) { ->(_original, user_id: nil) { user_id } }

      it "passes an empty positional Hash as no keywords" do
        expect(delegate.call(original, {})).to be_nil
      end
    end
  end
end
