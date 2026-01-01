# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Exceptions do
  describe Servactory::Stroma::Exceptions::Base do
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

  describe Servactory::Stroma::Exceptions::RegistryFrozen do
    it "inherits from Base" do
      expect(described_class.superclass).to eq(Servactory::Stroma::Exceptions::Base)
    end

    it "can be rescued as Base" do
      expect { raise described_class }.to raise_error(Servactory::Stroma::Exceptions::Base)
    end

    it "can be rescued as StandardError" do
      expect { raise described_class }.to raise_error(StandardError)
    end
  end

  describe Servactory::Stroma::Exceptions::RegistryNotFinalized do
    it "inherits from Base" do
      expect(described_class.superclass).to eq(Servactory::Stroma::Exceptions::Base)
    end

    it "can be rescued as Base" do
      expect { raise described_class }.to raise_error(Servactory::Stroma::Exceptions::Base)
    end
  end

  describe Servactory::Stroma::Exceptions::KeyAlreadyRegistered do
    it "inherits from Base" do
      expect(described_class.superclass).to eq(Servactory::Stroma::Exceptions::Base)
    end

    it "can be rescued as Base" do
      expect { raise described_class }.to raise_error(Servactory::Stroma::Exceptions::Base)
    end
  end

  describe Servactory::Stroma::Exceptions::UnknownHookTarget do
    it "inherits from Base" do
      expect(described_class.superclass).to eq(Servactory::Stroma::Exceptions::Base)
    end

    it "can be rescued as Base" do
      expect { raise described_class }.to raise_error(Servactory::Stroma::Exceptions::Base)
    end
  end
end
