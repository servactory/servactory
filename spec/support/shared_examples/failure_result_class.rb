# frozen_string_literal: true

RSpec.shared_examples "failure result class" do
  it "returns failure result class", :aggregate_failures do
    result = perform

    expect(result).to be_a(Servactory::Result)
    expect(result).to an_instance_of(ApplicationService::Result)
    expect(result.success?).to be(false)

    expect(result.failure?).to be(true)
    expect(result.failure?(:all)).to be(true)
    expect(result.failure?(:base)).to be(true)

    if result.error.is_a?(Servactory::Exceptions::Input) ||
       result.error.is_a?(Servactory::Exceptions::Internal) ||
       result.error.is_a?(Servactory::Exceptions::Output)
      expect(result.failure?(:non_existent)).to be(true)
    else
      expect(result.failure?(:non_existent)).to be(false)
    end
  end
end
