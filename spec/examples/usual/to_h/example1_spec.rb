# frozen_string_literal: true

RSpec.describe Usual::ToH::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:full_name, "John Fitzgerald Kennedy")
          )
        end

        it "returns the result as a hash" do
          expect(perform.to_h).to match(
            full_name: "John Fitzgerald Kennedy"
          )
        end

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it do
            expect(perform).to(
              be_success_service
                .with_output(:full_name, "John Kennedy")
            )
          end

          it "returns the result as a hash" do
            expect(perform.to_h).to match(
              full_name: "John Kennedy"
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[full_name]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:full_name, "John Fitzgerald Kennedy")
          )
        end

        it "returns the result as a hash" do
          expect(perform.to_h).to match(
            full_name: "John Fitzgerald Kennedy"
          )
        end

        describe "even if `middle_name` is not specified" do
          let(:middle_name) { nil }

          it do
            expect(perform).to(
              be_success_service
                .with_output(:full_name, "John Kennedy")
            )
          end

          it "returns the result as a hash" do
            expect(perform.to_h).to match(
              full_name: "John Kennedy"
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:first_name).valid_with(attributes).type(String).required }
      it { expect { perform }.to have_input(:middle_name).valid_with(attributes).type(String).optional }
      it { expect { perform }.to have_input(:last_name).valid_with(attributes).type(String).required }
    end
  end
end
