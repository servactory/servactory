# frozen_string_literal: true

RSpec.shared_examples "success result class" do
  it "returns success result class", :aggregate_failures do
    result = perform

    expect(result).to be_a(Servactory::Result)
    expect(result).to an_instance_of(ApplicationService::Result)
    expect(result.success?).to be(true)
    expect(result.failure?).to be(false)
  end
end
