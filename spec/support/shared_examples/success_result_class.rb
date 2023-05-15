# frozen_string_literal: true

RSpec.shared_examples "success result class" do
  it "returns expected result class and statuses", :aggregate_failures do
    result = perform

    expect(result).to be_a(Servactory::Result)
    expect(result.success?).to be(true)
    expect(result.failure?).to be(false)
  end
end
