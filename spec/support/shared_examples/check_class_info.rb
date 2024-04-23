# frozen_string_literal: true

RSpec.shared_examples "check class info" do |inputs: [], internals: [], outputs: []|
  it "returns expected information about class", :aggregate_failures do
    expect(described_class.info.inputs.keys).to match_array(inputs)
    expect(described_class.info.internals.keys).to match_array(internals)
    expect(described_class.info.outputs.keys).to match_array(outputs)
  end
end
