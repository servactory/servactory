# frozen_string_literal: true

RSpec.shared_examples "result class" do
  it "returns expected result class" do
    result = perform

    expect(result).to be_a(Servactory::Result)
  end
end
