# frozen_string_literal: true

RSpec.describe Usual::Basic::Example15, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:,
        gender:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name gender],
                    internals: %i[],
                    outputs: %i[first_name middle_name last_name full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:middle_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:gender)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:first_name)
              .instance_of(String)
          )
        end
      end

      it do
        expect(perform).to(
          have_output(:middle_name)
            .instance_of(String)
        )
      end

      it do
        expect(perform).to(
          have_output(:last_name)
            .instance_of(String)
        )
      end

      it do
        expect(perform).to(
          have_output(:full_name)
            .instance_of(String)
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              first_name: "JOHN",
              middle_name: "FITZGERALD",
              last_name: "KENNEDY",
              full_name: "JOHN FITZGERALD KENNEDY"
            )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:,
        gender:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:gender) { "Male" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name gender],
                    internals: %i[],
                    outputs: %i[first_name middle_name last_name full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:middle_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:gender)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:first_name)
              .instance_of(String)
          )
        end
      end

      it do
        expect(perform).to(
          have_output(:middle_name)
            .instance_of(String)
        )
      end

      it do
        expect(perform).to(
          have_output(:last_name)
            .instance_of(String)
        )
      end

      it do
        expect(perform).to(
          have_output(:full_name)
            .instance_of(String)
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              first_name: "JOHN",
              middle_name: "FITZGERALD",
              last_name: "KENNEDY",
              full_name: "JOHN FITZGERALD KENNEDY"
            )
        )
      end
    end
  end
end
