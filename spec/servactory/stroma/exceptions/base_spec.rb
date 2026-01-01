# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Exceptions::Base do
  it "inherits from StandardError" do
    expect(described_class.superclass).to eq(StandardError)
  end

  it "can be raised and rescued" do
    expect { raise described_class, "test" }.to raise_error(StandardError)
  end

  it "preserves the error message" do
    expect { raise described_class, "custom message" }.to raise_error(
      described_class,
      "custom message"
    )
  end
end
