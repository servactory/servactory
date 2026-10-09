# frozen_string_literal: true

RSpec.describe Servactory::Utils do
  describe ".adaptable?" do
    it "accepts a Hash" do
      expect(described_class.adaptable?({ id: 1 })).to be(true)
    end

    it "accepts HashWithIndifferentAccess" do
      expect(described_class.adaptable?(ActiveSupport::HashWithIndifferentAccess.new(id: 1))).to be(true)
    end

    it "accepts a Datory object" do
      event = Usual::Datory::Example1::Event.deserialize(id: "0b9c4c2e-6a1d-4f7e-9b3a-2f1d5c8e7a64")

      expect(described_class.adaptable?(event)).to be(true)
    end

    it "rejects nil" do
      expect(described_class.adaptable?(nil)).to be(false)
    end

    it "rejects an Array of pairs" do
      expect(described_class.adaptable?([[:id, 1]])).to be(false)
    end
  end
end
