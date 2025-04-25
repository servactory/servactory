# frozen_string_literal: true

RSpec.shared_examples "failure result class" do
  it "returns failure result class", :aggregate_failures do # rubocop:disable RSpec/ExampleLength
    result = perform

    expect(result).to be_a(Servactory::Result)
    expect(result).to an_instance_of(ApplicationService::Result)
    expect(result.success?).to be(false)
    expect(result.failure?).to be(true)
    expect(result.failure?(:all)).to be(true)
    expect(result.failure?(:base)).to be(true)
    expect(result.failure?(:non_existent)).to be(false)
    expect(result.error.all?).to be(false) # because it doesn't make sense
    expect(result.error.base?).to be(true)
    expect(result.error.non_existent?).to be(false)
    expect(result.error.respond_to?(:all?)).to be(false) # because it doesn't make sense
    expect(result.error.respond_to?(:base?)).to be(true)
    expect(result.error.respond_to?(:non_existent?)).to be(false)

    # NOTE: Testing the matcher.
    # NOTE: Testing the matcher without anything.
    expect(result).to be_failure_service
    # NOTE: Testing the matcher with all chains.
    expect(result).to(
      be_failure_service
        .type(:base)
        .with(ApplicationService::Exceptions::Failure)
        .message(result.error.message) # Just checking the chain.
        .meta(result.error.meta) # Just checking the chain.
    )
  end
end
