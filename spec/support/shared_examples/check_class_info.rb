# frozen_string_literal: true

RSpec.shared_examples "check class info" do |inputs: [], internals: [], outputs: []|
  it "returns expected information about class", :aggregate_failures do
    expect(described_class.info.inputs).to match_array(inputs)
    expect(described_class.info.internals).to match_array(internals)
    expect(described_class.info.outputs).to match_array(outputs)
  end
end
