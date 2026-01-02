# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Duration::Optional::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        song_duration:
      }
    end

    let(:song_duration) { nil }

    it_behaves_like "check class info",
                    inputs: %i[song_duration],
                    internals: %i[song_duration],
                    outputs: %i[song_duration]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:song_duration, nil)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `duration`" do
        let(:song_duration) { "7D" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Usual::DynamicOptions::Format::Duration::Optional::Example2] Internal attribute `song_duration` " \
              "does not match `duration` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:song_duration)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        song_duration:
      }
    end

    let(:song_duration) { nil }

    it_behaves_like "check class info",
                    inputs: %i[song_duration],
                    internals: %i[song_duration],
                    outputs: %i[song_duration]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:song_duration, nil)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `duration`" do
        let(:song_duration) { "7D" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "[Usual::DynamicOptions::Format::Duration::Optional::Example2] Internal attribute `song_duration` " \
              "does not match `duration` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:song_duration)
              .valid_with(attributes)
              .type(String)
              .optional
          )
        end
      end
    end
  end
end
