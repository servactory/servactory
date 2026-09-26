# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example15, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[payload],
                    outputs: %i[]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(ActiveSupport::HashWithIndifferentAccess)
              .schema({ name: { type: String } })
          )
        end
      end
    end

    describe "but the internal attribute type is not configured as Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::Schema::Example15] Wrong type of internal attribute `payload`, " \
            "expected `Hash`, got `ActiveSupport::HashWithIndifferentAccess`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[payload],
                    outputs: %i[]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(ActiveSupport::HashWithIndifferentAccess)
              .schema({ name: { type: String } })
          )
        end
      end
    end

    describe "but the internal attribute type is not configured as Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::Schema::Example15] Wrong type of internal attribute `payload`, " \
            "expected `Hash`, got `ActiveSupport::HashWithIndifferentAccess`"
          )
        )
      end
    end
  end
end
