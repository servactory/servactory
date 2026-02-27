# frozen_string_literal: true

RSpec.shared_examples "success result class" do
  it "returns success" do
    expect(perform).to be_success_service
  end
end
