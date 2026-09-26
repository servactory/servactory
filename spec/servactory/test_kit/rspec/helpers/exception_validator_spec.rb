# frozen_string_literal: true

RSpec.describe Servactory::TestKit::Rspec::Helpers::ExceptionValidator do
  describe ".validate!" do
    subject(:validate) { described_class.validate!(config) }

    let(:service_class) { Class.new(AlternativeService::Base) }

    let(:config) do
      Servactory::TestKit::Rspec::Helpers::ServiceMockConfig.new(service_class:).tap do |config|
        config.method_type = method_type
        config.result_type = result_type
        config.exception = exception
      end
    end

    let(:method_type) { :call }
    let(:result_type) { :failure }
    let(:exception) { AlternativeService::Exceptions::Failure.new(message: "Failed") }

    context "when the success config has no exception" do
      let(:result_type) { :success }
      let(:exception) { nil }

      it { expect { validate }.not_to raise_error }
    end

    context "when the failure config has no exception" do
      let(:exception) { nil }

      it { expect { validate }.to raise_error(ArgumentError, /Exception is required for failure mock/) }
    end

    context "when mocking call with a sibling failure class" do
      let(:exception) { ApplicationService::Exceptions::Failure.new(message: "Failed") }

      it { expect { validate }.not_to raise_error }
    end

    context "when mocking call with an exception outside Servactory failures" do
      let(:exception) { StandardError.new("Failed") }

      it { expect { validate }.to raise_error(ArgumentError, /Invalid exception type for failure mock/) }
    end

    context "when mocking call! with the configured failure class" do
      let(:method_type) { :call! }

      it { expect { validate }.not_to raise_error }
    end

    context "when mocking call! with a sibling failure class" do
      let(:method_type) { :call! }
      let(:exception) { ApplicationService::Exceptions::Failure.new(message: "Failed") }

      it { expect { validate }.to raise_error(ArgumentError, /Invalid exception type for failure mock/) }
    end
  end
end
