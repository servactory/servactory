# frozen_string_literal: true

RSpec.describe Servactory::VERSION do
  it { expect(Servactory::VERSION::STRING).to be_present }
end
