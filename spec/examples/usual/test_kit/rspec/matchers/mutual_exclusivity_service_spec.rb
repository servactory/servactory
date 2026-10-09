# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::Matchers::MutualExclusivityService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        required_field: "Value"
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[required_field optional_field],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        context "when `required` is chained after `optional`" do
          it do
            expect { perform }.to(
              have_input(:required_field)
                .valid_with(attributes)
                .type(String)
                .optional
                .required
            )
          end

          it "fails for an optional input", :aggregate_failures do
            matcher = have_input(:optional_field).type(String).optional.required

            expect(matcher.matches?(nil)).to be(false)
            expect(matcher.failure_message).to eq(
              "Expected #{described_class.name} to have a service input attribute named optional_field, " \
              "which should be required\n\n  expected required: true\n       got required: false\n"
            )
          end
        end

        context "when `optional` is chained after `required`" do
          it do
            expect { perform }.to(
              have_input(:optional_field)
                .valid_with(attributes)
                .type(String)
                .required
                .optional
            )
          end

          it "fails for a required input", :aggregate_failures do
            matcher = have_input(:required_field).type(String).required.optional

            expect(matcher.matches?(nil)).to be(false)
            expect(matcher.failure_message).to eq(
              "Expected #{described_class.name} to have a service input attribute named required_field, " \
              "which should be optional\n\n  expected required: false\n       got required: true\n"
            )
          end
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"
    end

    describe "but the data required for work is invalid" do
      describe "because `required_field` is not passed" do
        let(:attributes) { {} }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[#{described_class.name}] Required input `required_field` is missing"
            )
          )
        end
      end
    end
  end
end
