# frozen_string_literal: true

RSpec.describe Servactory::Configuration::Config do
  describe "#dup" do
    context "when user option helpers coexist with rebound built-in helpers" do
      let(:collection_class) { Class.new(Array) }
      let(:hash_class) { Class.new(Hash) }

      let(:positive_helper) do
        Servactory::Maintenance::Options::Helper.new(
          name: :positive,
          equivalent: {
            must: {
              be_positive: {
                is: ->(value:, **) { value.positive? },
                message: "Must be positive"
              }
            }
          }
        )
      end

      let(:parent_class) do
        helper = positive_helper
        collection = collection_class

        Class.new(ApplicationService::Base) do
          configuration do
            input_option_helpers([helper])
            internal_option_helpers([helper])
            output_option_helpers([helper])
            collection_mode_class_names([collection])
          end
        end
      end

      let(:child_class) do
        hash = hash_class

        Class.new(parent_class) do
          configuration do
            hash_mode_class_names([hash])
          end
        end
      end

      let(:grandchild_class) do
        collection = collection_class
        hash = hash_class

        Class.new(child_class) do
          input :number, :positive, type: Integer
          input :items, type: collection, consists_of: String
          input :payload, type: hash, schema: { name: { type: String } }

          output :number, type: Integer

          make :assign_number

          private

          def assign_number
            outputs.number = inputs.number
          end
        end
      end

      let(:attributes) do
        {
          number: 1,
          items: collection_class.new(%w[first second]),
          payload: hash_class[name: "John"]
        }
      end

      it "keeps a single helper per name on every level", :aggregate_failures do
        service_classes = [parent_class, child_class, grandchild_class]
        config_names = %i[input_option_helpers internal_option_helpers output_option_helpers]

        service_classes.product(config_names).each do |service_class, config_name|
          names = service_class.config.public_send(config_name).map(&:name)

          expect(names).to eq(names.uniq)
        end
      end

      it "keeps user helpers untouched on every level" do
        expect(
          [parent_class, child_class, grandchild_class].map do |service_class|
            service_class.config.input_option_helpers.find_by(name: :positive)
          end
        ).to all(be(positive_helper))
      end

      it "rebinds built-in helpers on every level", :aggregate_failures do
        %i[consists_of schema].each do |name|
          helpers = [parent_class, child_class, grandchild_class].map do |service_class|
            service_class.config.input_option_helpers.find_by(name:)
          end

          expect(helpers.uniq(&:object_id).size).to eq(3)
        end
      end

      it "applies user and rebound built-in helpers", :aggregate_failures do
        expect(grandchild_class.call!(**attributes)).to have_attributes(number: 1)
        expect { grandchild_class.call!(**attributes, number: -1) }.to raise_error(
          ApplicationService::Exceptions::Input,
          "Must be positive"
        )
        expect { grandchild_class.call!(**attributes, items: collection_class.new([1])) }.to raise_error(
          ApplicationService::Exceptions::Input,
          /Wrong element type in input collection `items`/
        )
        expect { grandchild_class.call!(**attributes, payload: hash_class[name: 1]) }.to raise_error(
          ApplicationService::Exceptions::Input,
          /Wrong type in input hash `payload`/
        )
      end
    end
  end
end
