# frozen_string_literal: true

RSpec.describe Servactory::VERSION do
  it { expect(Servactory::VERSION::STRING).not_to be_nil }
end
