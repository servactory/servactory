# frozen_string_literal: true

RSpec.describe Servactory::Outputs::DSL do
  let(:service_class) { stub_const("Orders::Create", Class.new(Servactory::Base)) }

  describe ".output" do
    describe "without a usable `type` option" do
      {
        "no `type` option" => {},
        "`type: nil`" => { type: nil },
        "`type: []`" => { type: [] },
        "`type: {}`" => { type: {} },
        "an advanced mode without `is`" => { type: { message: "Order must be a Hash" } },
        "an advanced mode with `is: nil`" => { type: { is: nil } },
        "an advanced mode with `is: []`" => { type: { is: [] } }
      }.each do |description, options|
        it "raises ArgumentError for #{description}" do
          expect { service_class.class_eval { output :order, **options } }.to raise_error(
            ArgumentError,
            "[Orders::Create] Output attribute `order` must have the `type` option"
          )
        end
      end

      it "does not register the output attribute", :aggregate_failures do
        expect { service_class.class_eval { output :order } }.to raise_error(ArgumentError)

        expect(service_class.info.outputs).to be_empty
      end
    end

    describe "with a usable `type` option" do
      {
        "`type: Hash`" => [{ type: Hash }, [Hash]],
        "`type: [Hash, Array]`" => [{ type: [Hash, Array] }, [Hash, Array]],
        "an advanced mode with `is: Hash`" => [{ type: { is: Hash } }, [Hash]],
        "an advanced mode with `is` and `message`" => [
          { type: { is: [Hash, Array], message: "Order must be a Hash or an Array" } },
          [Hash, Array]
        ]
      }.each do |description, (options, types)|
        it "declares the output attribute for #{description}" do
          service_class.class_eval { output :order, **options }

          expect(service_class.info.outputs.dig(:order, :types)).to eq(types)
        end
      end
    end
  end
end
