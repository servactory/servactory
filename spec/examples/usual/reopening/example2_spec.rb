# frozen_string_literal: true

RSpec.describe Usual::Reopening::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        last_name:
      }
    end

    let(:first_name) { "john" }
    let(:last_name) { "kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name last_name],
                    internals: %i[prepared_first_name prepared_full_name],
                    outputs: %i[greeting full_name]

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
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:prepared_first_name)
              .type(String)
          )
        end

        it do
          expect { perform }.to(
            have_internal(:prepared_full_name)
              .type(String)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
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
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              greeting: "Hello, John!",
              full_name: "John Kennedy"
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
        last_name:
      }
    end

    let(:first_name) { "john" }
    let(:last_name) { "kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name last_name],
                    internals: %i[prepared_first_name prepared_full_name],
                    outputs: %i[greeting full_name]

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
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:prepared_first_name)
              .type(String)
          )
        end

        it do
          expect { perform }.to(
            have_internal(:prepared_full_name)
              .type(String)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
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
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              greeting: "Hello, John!",
              full_name: "John Kennedy"
            )
        )
      end
    end
  end
end
