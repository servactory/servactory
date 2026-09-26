# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount:,
        comment:,
        quantity:
      }
    end

    let(:amount) { 5 }
    let(:comment) { nil }
    let(:quantity) { -2 }

    it_behaves_like "check class info",
                    inputs: %i[amount comment quantity],
                    internals: %i[total],
                    outputs: %i[total]

    describe "info" do
      it "exposes the redeclared attributes", :aggregate_failures do
        expect(described_class.info.inputs.dig(:amount, :types)).to eq([Integer])
        expect(described_class.info.inputs.dig(:comment, :required, :is)).to be(false)
        expect(described_class.info.inputs.dig(:quantity, :must).keys).to eq(%i[be_even])
        expect(described_class.info.internals.dig(:total, :types)).to eq([Integer])
        expect(described_class.info.outputs.dig(:total, :types)).to eq([Integer])
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:amount)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:comment)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end

        it do
          expect { perform }.to(
            have_input(:quantity)
              .valid_with(attributes)
              .type(Integer)
              .required
              .must(:be_even)
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:total)
              .type(Integer)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:total)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:total, -10)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `amount` has the type declared by the parent" do
        let(:amount) { "5" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Inheritance::Example4] Wrong type of input `amount`, expected `Integer`, got `String`"
            )
          )
        end
      end

      describe "because `quantity` breaks the `be_even` rule" do
        let(:quantity) { 3 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Input `quantity` must be even"
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
        amount:,
        comment:,
        quantity:
      }
    end

    let(:amount) { 5 }
    let(:comment) { nil }
    let(:quantity) { -2 }

    it_behaves_like "check class info",
                    inputs: %i[amount comment quantity],
                    internals: %i[total],
                    outputs: %i[total]

    describe "info" do
      it "exposes the redeclared attributes", :aggregate_failures do
        expect(described_class.info.inputs.dig(:amount, :types)).to eq([Integer])
        expect(described_class.info.inputs.dig(:comment, :required, :is)).to be(false)
        expect(described_class.info.inputs.dig(:quantity, :must).keys).to eq(%i[be_even])
        expect(described_class.info.internals.dig(:total, :types)).to eq([Integer])
        expect(described_class.info.outputs.dig(:total, :types)).to eq([Integer])
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:amount)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:comment)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end

        it do
          expect { perform }.to(
            have_input(:quantity)
              .valid_with(attributes)
              .type(Integer)
              .required
              .must(:be_even)
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:total)
              .type(Integer)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:total)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:total, -10)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `amount` has the type declared by the parent" do
        let(:amount) { "5" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::Inheritance::Example4] Wrong type of input `amount`, expected `Integer`, got `String`"
            )
          )
        end
      end

      describe "because `quantity` breaks the `be_even` rule" do
        let(:quantity) { 3 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "Input `quantity` must be even"
            )
          )
        end
      end
    end
  end

  describe Usual::Inheritance::Example4Base do
    describe ".call!" do
      subject(:perform) { described_class.call!(**attributes) }

      let(:attributes) do
        {
          amount:,
          comment:,
          quantity:
        }
      end

      let(:amount) { "5" }
      let(:comment) { "Urgent" }
      let(:quantity) { 2 }

      it_behaves_like "check class info",
                      inputs: %i[amount comment quantity],
                      internals: %i[total],
                      outputs: %i[total]

      describe "info" do
        it "exposes the original attributes", :aggregate_failures do
          expect(described_class.info.inputs.dig(:amount, :types)).to eq([String])
          expect(described_class.info.inputs.dig(:comment, :required, :is)).to be(true)
          expect(described_class.info.inputs.dig(:quantity, :must).keys).to eq(%i[be_positive])
          expect(described_class.info.internals.dig(:total, :types)).to eq([String])
          expect(described_class.info.outputs.dig(:total, :types)).to eq([String])
        end
      end

      describe "validations" do
        describe "inputs" do
          it do
            expect { perform }.to(
              have_input(:amount)
                .valid_with(attributes)
                .type(String)
                .required
            )
          end

          it do
            expect { perform }.to(
              have_input(:comment)
                .valid_with(attributes)
                .type(String)
                .required
            )
          end

          it do
            expect { perform }.to(
              have_input(:quantity)
                .valid_with(attributes)
                .type(Integer)
                .required
                .must(:be_positive)
            )
          end
        end

        describe "internals" do
          it do
            expect { perform }.to(
              have_internal(:total)
                .type(String)
            )
          end
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:total)
                .instance_of(String)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, "5 x 2")
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because `amount` has the type declared by the child" do
          let(:amount) { 5 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inheritance::Example4Base] Wrong type of input `amount`, expected `String`, got `Integer`"
              )
            )
          end
        end

        describe "because `comment` is not passed" do
          let(:comment) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inheritance::Example4Base] Required input `comment` is missing"
              )
            )
          end
        end

        describe "because `quantity` breaks the `be_positive` rule" do
          let(:quantity) { -2 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "Input `quantity` must be positive"
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
          amount:,
          comment:,
          quantity:
        }
      end

      let(:amount) { "5" }
      let(:comment) { "Urgent" }
      let(:quantity) { 2 }

      it_behaves_like "check class info",
                      inputs: %i[amount comment quantity],
                      internals: %i[total],
                      outputs: %i[total]

      describe "info" do
        it "exposes the original attributes", :aggregate_failures do
          expect(described_class.info.inputs.dig(:amount, :types)).to eq([String])
          expect(described_class.info.inputs.dig(:comment, :required, :is)).to be(true)
          expect(described_class.info.inputs.dig(:quantity, :must).keys).to eq(%i[be_positive])
          expect(described_class.info.internals.dig(:total, :types)).to eq([String])
          expect(described_class.info.outputs.dig(:total, :types)).to eq([String])
        end
      end

      describe "validations" do
        describe "inputs" do
          it do
            expect { perform }.to(
              have_input(:amount)
                .valid_with(attributes)
                .type(String)
                .required
            )
          end

          it do
            expect { perform }.to(
              have_input(:comment)
                .valid_with(attributes)
                .type(String)
                .required
            )
          end

          it do
            expect { perform }.to(
              have_input(:quantity)
                .valid_with(attributes)
                .type(Integer)
                .required
                .must(:be_positive)
            )
          end
        end

        describe "internals" do
          it do
            expect { perform }.to(
              have_internal(:total)
                .type(String)
            )
          end
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:total)
                .instance_of(String)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, "5 x 2")
          )
        end
      end

      describe "but the data required for work is invalid" do
        describe "because `amount` has the type declared by the child" do
          let(:amount) { 5 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inheritance::Example4Base] Wrong type of input `amount`, expected `String`, got `Integer`"
              )
            )
          end
        end

        describe "because `comment` is not passed" do
          let(:comment) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inheritance::Example4Base] Required input `comment` is missing"
              )
            )
          end
        end

        describe "because `quantity` breaks the `be_positive` rule" do
          let(:quantity) { -2 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "Input `quantity` must be positive"
              )
            )
          end
        end
      end
    end
  end
end
