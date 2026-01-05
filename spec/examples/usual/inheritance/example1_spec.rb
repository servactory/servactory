# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        input_1:,
        input_2:,
        input_3:
      }
    end

    let(:input_1) { "First" }
    let(:input_2) { "Second" }
    let(:input_3) { "Third" }

    it_behaves_like "check class info",
                    inputs: %i[input_1 input_2 input_3],
                    internals: %i[],
                    outputs: %i[output_1 output_2 output_3]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:input_1)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:output_1)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:output_2)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:output_3)
              .instance_of(String)
          )
        end
      end

      it do
        expect { perform }.to(
          have_input(:input_2)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:input_3)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:output_1, "First")
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:output_2, "Second")
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:output_3, "Third")
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        input_1:,
        input_2:,
        input_3:
      }
    end

    let(:input_1) { "First" }
    let(:input_2) { "Second" }
    let(:input_3) { "Third" }

    it_behaves_like "check class info",
                    inputs: %i[input_1 input_2 input_3],
                    internals: %i[],
                    outputs: %i[output_1 output_2 output_3]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:input_1)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:output_1)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:output_2)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:output_3)
              .instance_of(String)
          )
        end
      end

      it do
        expect { perform }.to(
          have_input(:input_2)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:input_3)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:output_1, "First")
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:output_2, "Second")
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:output_3, "Third")
        )
      end
    end
  end
end
