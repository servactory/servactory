# frozen_string_literal: true

RSpec.describe ServiceFactory::VERSION do
  it { expect(ServiceFactory::VERSION::STRING).not_to be_nil }
end
