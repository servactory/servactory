# frozen_string_literal: true

RSpec.shared_examples "check class info" do |inputs: [], internals: [], outputs: []|
  it "returns expected information about class", :aggregate_failures do
    expect(described_class.respond_to?(:info)).to be(true)
    expect(described_class.info).to be_a(Servactory::Info::Result)

    expect(described_class.info.respond_to?(:inputs)).to be(true)
    expect(described_class.info.inputs.keys).to match_array(inputs)

    expect(described_class.info.respond_to?(:internals)).to be(true)
    expect(described_class.info.internals.keys).to match_array(internals)

    expect(described_class.info.respond_to?(:outputs)).to be(true)
    expect(described_class.info.outputs.keys).to match_array(outputs)

    expect(described_class.info.respond_to?(:stages)).to be(true)

    expect(described_class.respond_to?(:servactory?)).to be(true)
    expect(described_class.servactory?).to be(true)
  end
end
