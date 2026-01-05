# frozen_string_literal: true

RSpec.shared_examples "generates valid Ruby syntax" do |file_path|
  it "generates syntactically valid Ruby" do
    content = file_content(file_path)
    expect { RubyVM::InstructionSequence.compile(content) }.not_to raise_error
  end
end
