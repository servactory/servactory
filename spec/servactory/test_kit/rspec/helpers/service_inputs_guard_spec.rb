# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Helpers::ServiceInputsGuard do
  let(:guard) { described_class.new(service_class:, method_type: :call!) }

  let(:service_class) do
    Class.new(ApplicationService::Base) do
      input :user_id, type: Integer
      input :locale, type: String, required: false
    end
  end

  before do
    stub_const("ServiceInputsGuardExample", service_class)
  end

  describe "#verify!" do
    context "without an inputs matcher" do
      it "accepts any arguments" do
        expect { guard.verify!([{ page: 2 }, :extra]) }.not_to raise_error
      end
    end

    context "with an inputs matcher" do
      before do
        guard.inputs_matcher = Servactory::TestKit::Rspec::Helpers::ServiceInputsMatcher.new(
          service_class.info.inputs
        )
      end

      it "accepts matching inputs" do
        expect { guard.verify!([{ user_id: 1 }]) }.not_to raise_error
      end

      it "rejects inputs without a required input" do
        expect { guard.verify!([{ locale: "en" }]) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          <<~MESSAGE.chomp
            #<ServiceInputsGuardExample (class)> received :call! with unexpected arguments
              expected: (service_inputs(required: [:user_id], optional: [:locale]))
                   got: (#{RSpec::Support::ObjectFormatter.format({ locale: 'en' })})
          MESSAGE
        )
      end

      it "rejects a call without arguments" do
        expect { guard.verify!([]) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :call! with unexpected arguments\n.*\n\s+got: \(no args\)\z/
        )
      end
    end
  end
end
