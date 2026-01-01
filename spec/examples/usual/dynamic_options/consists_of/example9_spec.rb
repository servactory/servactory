# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        letters:
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F], nil, ""]]
    end

    it_behaves_like "check class info",
                    inputs: %i[letters],
                    internals: %i[letters],
                    outputs: %i[letters desired_letter]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:letters)
              .valid_with(attributes)
              .type(Array)
              .consists_of(String, NilClass)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:letters)
              .instance_of(Array)
          )
        end

        it do
          expect(perform).to(
            have_output(:desired_letter)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:letters?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:letters, [%w[A B], ["C", "D", %w[E F], nil, ""]])
        )
      end

      it do
        expect(perform).to(
          have_output(:desired_letter?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:desired_letter, "E")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element has the wrong type" do
        let(:letters) do
          [%w[A B], ["C", :D, %w[E F]]]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example9] Wrong element type in input collection `letters`, " \
              "expected `String, NilClass`, got `Symbol`"
            )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        letters:
      }
    end

    let(:letters) do
      [%w[A B], ["C", "D", %w[E F], nil, ""]]
    end

    it_behaves_like "check class info",
                    inputs: %i[letters],
                    internals: %i[letters],
                    outputs: %i[letters desired_letter]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:letters)
              .valid_with(attributes)
              .type(Array)
              .consists_of(String, NilClass)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:letters)
              .instance_of(Array)
          )
        end

        it do
          expect(perform).to(
            have_output(:desired_letter)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:letters?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:letters, [%w[A B], ["C", "D", %w[E F], nil, ""]])
        )
      end

      it do
        expect(perform).to(
          have_output(:desired_letter?).contains(true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:desired_letter, "E")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element has the wrong type" do
        let(:letters) do
          [%w[A B], ["C", :D, %w[E F]]]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example9] Wrong element type in input collection `letters`, " \
              "expected `String, NilClass`, got `Symbol`"
            )
          )
        end
      end
    end
  end
end
