# frozen_string_literal: true

RSpec.describe Servactory::Internals::DSL do
  let(:service_class) { stub_const("Orders::Create", Class.new(Servactory::Base)) }

  describe ".internal" do
    describe "without a usable `type` option" do
      {
        "no `type` option" => {},
        "`type: nil`" => { type: nil },
        "`type: []`" => { type: [] },
        "`type: {}`" => { type: {} },
        "an advanced mode without `is`" => { type: { message: "Total must be a number" } },
        "an advanced mode with `is: nil`" => { type: { is: nil } },
        "an advanced mode with `is: []`" => { type: { is: [] } }
      }.each do |description, options|
        it "raises ArgumentError for #{description}" do
          expect { service_class.class_eval { internal :total, **options } }.to raise_error(
            ArgumentError,
            "[Orders::Create] Internal attribute `total` must have the `type` option"
          )
        end
      end

      it "does not register the internal attribute", :aggregate_failures do
        expect { service_class.class_eval { internal :total } }.to raise_error(ArgumentError)

        expect(service_class.info.internals).to be_empty
      end
    end

    describe "with a usable `type` option" do
      {
        "`type: Hash`" => [{ type: Hash }, [Hash]],
        "`type: [Integer, Float]`" => [{ type: [Integer, Float] }, [Integer, Float]],
        "an advanced mode with `is: Hash`" => [{ type: { is: Hash } }, [Hash]],
        "an advanced mode with `is` and `message`" => [
          { type: { is: [Integer, Float], message: "Total must be a number" } },
          [Integer, Float]
        ]
      }.each do |description, (options, types)|
        it "declares the internal attribute for #{description}" do
          service_class.class_eval { internal :total, **options }

          expect(service_class.info.internals.dig(:total, :types)).to eq(types)
        end
      end
    end
  end
end
