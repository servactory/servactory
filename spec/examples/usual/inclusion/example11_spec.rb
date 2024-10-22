# frozen_string_literal: true

RSpec.describe Usual::Inclusion::Example11, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        entity_class:
      }
    end

    let(:entity_class) { Usual::Inclusion::Example11::ThirdEntity }

    include_examples "check class info",
                     inputs: %i[entity_class],
                     internals: %i[entity_class],
                     outputs: %i[entity_class]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:entity_class).contains(Usual::Inclusion::Example11::ThirdEntity) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `entity_class` is wrong" do
          let(:entity_class) { Usual::Inclusion::Example11::FakeEntity }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inclusion::Example11] Wrong value in `entity_class`, must be one of " \
                "`[Usual::Inclusion::Example11::FirstEntity, Usual::Inclusion::Example11::SecondEntity, " \
                "Usual::Inclusion::Example11::ThirdEntity]`"
              )
            )
          end
        end

        describe "because the value of `entity_class` is not suitable for `internal`" do
          let(:entity_class) { Usual::Inclusion::Example11::FirstEntity }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::Inclusion::Example11] Wrong value in `entity_class`, must be one of " \
                "`[Usual::Inclusion::Example11::SecondEntity, Usual::Inclusion::Example11::ThirdEntity]`"
              )
            )
          end
        end

        describe "because the value of `entity_class` is not suitable for `output`" do
          let(:entity_class) { Usual::Inclusion::Example11::SecondEntity }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::Inclusion::Example11] Wrong value in `entity_class`, must be one of " \
                "`[Usual::Inclusion::Example11::ThirdEntity]`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:entity_class)
            .valid_with(attributes)
            .type(Class)
            .required
            .inclusion(
              [
                Usual::Inclusion::Example11::FirstEntity,
                Usual::Inclusion::Example11::SecondEntity,
                Usual::Inclusion::Example11::ThirdEntity
              ]
            )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        entity_class:
      }
    end

    let(:entity_class) { Usual::Inclusion::Example11::ThirdEntity }

    include_examples "check class info",
                     inputs: %i[entity_class],
                     internals: %i[entity_class],
                     outputs: %i[entity_class]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it { expect(perform).to have_output(:entity_class).contains(Usual::Inclusion::Example11::ThirdEntity) }
      end

      describe "but the data required for work is invalid" do
        describe "because the value of `entity_class` is wrong" do
          let(:entity_class) { Usual::Inclusion::Example11::FakeEntity }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Inclusion::Example11] Wrong value in `entity_class`, must be one of " \
                "`[Usual::Inclusion::Example11::FirstEntity, Usual::Inclusion::Example11::SecondEntity, " \
                "Usual::Inclusion::Example11::ThirdEntity]`"
              )
            )
          end
        end

        describe "because the value of `entity_class` is not suitable for `internal`" do
          let(:entity_class) { Usual::Inclusion::Example11::FirstEntity }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::Inclusion::Example11] Wrong value in `entity_class`, must be one of " \
                "`[Usual::Inclusion::Example11::SecondEntity, Usual::Inclusion::Example11::ThirdEntity]`"
              )
            )
          end
        end

        describe "because the value of `entity_class` is not suitable for `output`" do
          let(:entity_class) { Usual::Inclusion::Example11::SecondEntity }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Output,
                "[Usual::Inclusion::Example11] Wrong value in `entity_class`, must be one of " \
                "`[Usual::Inclusion::Example11::ThirdEntity]`"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:entity_class)
            .valid_with(attributes)
            .type(Class)
            .required
            .inclusion(
              [
                Usual::Inclusion::Example11::FirstEntity,
                Usual::Inclusion::Example11::SecondEntity,
                Usual::Inclusion::Example11::ThirdEntity
              ]
            )
        )
      end
    end
  end
end
