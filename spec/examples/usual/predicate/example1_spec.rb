# frozen_string_literal: true

RSpec.describe Usual::Predicate::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        enable:,
        text:,
        number:
      }
    end

    let(:enable) { true }
    let(:text) { "text" }
    let(:number) { 47 }

    it_behaves_like "check class info",
                    inputs: %i[enable text number],
                    internals: %i[prepared_text prepared_number],
                    outputs: %i[
                      is_enabled is_really_enabled
                      is_text_present is_prepared_text_present
                      is_number_present is_prepared_number_present
                    ]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_enabled, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_really_enabled, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_text_present, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_prepared_text_present, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_number_present, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_prepared_number_present, true)
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:enable)
              .valid_with(attributes)
              .types(TrueClass, FalseClass)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:is_enabled)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_really_enabled)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_text_present)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_prepared_text_present)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_number_present)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_prepared_number_present)
              .instance_of(TrueClass)
          )
        end
      end

      it do
        expect { perform }.to(
          have_input(:text)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        enable:,
        text:,
        number:
      }
    end

    let(:enable) { true }
    let(:text) { "text" }
    let(:number) { 47 }

    it_behaves_like "check class info",
                    inputs: %i[enable text number],
                    internals: %i[prepared_text prepared_number],
                    outputs: %i[
                      is_enabled is_really_enabled
                      is_text_present is_prepared_text_present
                      is_number_present is_prepared_number_present
                    ]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_enabled, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_really_enabled, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_text_present, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_prepared_text_present, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_number_present, true)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:is_prepared_number_present, true)
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:enable)
              .valid_with(attributes)
              .types(TrueClass, FalseClass)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:is_enabled)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_really_enabled)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_text_present)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_prepared_text_present)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_number_present)
              .instance_of(TrueClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:is_prepared_number_present)
              .instance_of(TrueClass)
          )
        end
      end

      it do
        expect { perform }.to(
          have_input(:text)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:number)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end
end
