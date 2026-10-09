# frozen_string_literal: true

RSpec.describe Wrong::TestKit::Rspec::Matchers::StrictProcMessageService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        count: 1,
        status: :active,
        ids: [1, 2],
        config: { key: "value" },
        handler: described_class::Handler
      }
    end

    {
      count: [->(matcher) { matcher.type(Integer) }, "1"],
      status: [->(matcher) { matcher.type(Symbol).inclusion(%i[active inactive]) }, :unknown],
      ids: [->(matcher) { matcher.type(Array).consists_of(Integer) }, ["1"]],
      config: [->(matcher) { matcher.type(Hash).schema({ key: { type: String } }) }, { key: 1 }],
      handler: [->(matcher) { matcher.type(Class).target([described_class::Handler]) }, String]
    }.each do |input_name, (chain, invalid_value)|
      describe "with a Proc message of `#{input_name}` declaring only `input:`" do
        let(:matcher) { chain.call(have_input(input_name)).message("Input `#{input_name}` is invalid") }

        it "fails the message check", :aggregate_failures do
          expect(matcher.matches?(nil)).to be(false)
          expect(matcher.failure_message).to include("could not build the Proc message")
          expect(matcher.failure_message).to include("ArgumentError:")
        end

        it "raises the same error while the service runs" do
          attributes[input_name] = invalid_value

          expect { perform }.to raise_error(ArgumentError)
        end
      end
    end

    describe "and the data required for work is also valid" do
      it { expect(perform).to be_success_service }
    end
  end
end
