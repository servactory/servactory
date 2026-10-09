# frozen_string_literal: true

RSpec.describe Servactory::Inputs::DSL do
  let(:service_class) { stub_const("Orders::Create", Class.new(Servactory::Base)) }

  describe ".input" do
    describe "without a usable `type` option" do
      {
        "no `type` option" => {},
        "`type: nil`" => { type: nil },
        "`type: []`" => { type: [] },
        "`type: {}`" => { type: {} },
        "an advanced mode without `is`" => { type: { message: "Amount must be a number" } },
        "an advanced mode with `is: nil`" => { type: { is: nil } },
        "an advanced mode with `is: []`" => { type: { is: [] } }
      }.each do |description, options|
        it "raises ArgumentError for #{description}" do
          expect { service_class.class_eval { input :amount, **options } }.to raise_error(
            ArgumentError,
            "[Orders::Create] Input `amount` must have the `type` option"
          )
        end
      end

      it "does not register the input", :aggregate_failures do
        expect { service_class.class_eval { input :amount } }.to raise_error(ArgumentError)

        expect(service_class.info.inputs).to be_empty
      end
    end

    describe "with a usable `type` option" do
      {
        "`type: Hash`" => [{ type: Hash }, [Hash]],
        "`type: [Integer, Float]`" => [{ type: [Integer, Float] }, [Integer, Float]],
        "an advanced mode with `is: Hash`" => [{ type: { is: Hash } }, [Hash]],
        "an advanced mode with `is` and `message`" => [
          { type: { is: [Integer, Float], message: "Amount must be a number" } },
          [Integer, Float]
        ]
      }.each do |description, (options, types)|
        it "declares the input for #{description}" do
          service_class.class_eval { input :amount, **options }

          expect(service_class.info.inputs.dig(:amount, :types)).to eq(types)
        end
      end

      it "declares the input when the type comes from an option helper" do
        service_class.class_eval do
          configuration do
            input_option_helpers(
              [
                Servactory::Maintenance::Options::Helper.new(
                  name: :number,
                  equivalent: { type: [Integer, Float] }
                )
              ]
            )
          end

          input :amount, :number
        end

        expect(service_class.info.inputs.dig(:amount, :types)).to eq([Integer, Float])
      end
    end
  end
end
