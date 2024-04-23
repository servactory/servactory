# frozen_string_literal: true

RSpec.shared_examples "success result class" do
  it "returns success" do
    result = perform

    expect(result).to be_success_service
  end
end
