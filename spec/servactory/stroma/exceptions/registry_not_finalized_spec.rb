# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Exceptions::RegistryNotFinalized do
  it "inherits from Base" do
    expect(described_class.superclass).to eq(Servactory::Stroma::Exceptions::Base)
  end

  it "can be rescued as Base" do
    expect { raise described_class }.to raise_error(Servactory::Stroma::Exceptions::Base)
  end
end
