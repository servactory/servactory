# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Duration::Message::Lambda::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        song_duration:
      }
    end

    let(:song_duration) { "P7D" }

    it_behaves_like "check class info",
                    inputs: %i[song_duration],
                    internals: %i[song_duration],
                    outputs: %i[song_duration]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              song_duration: ActiveSupport::Duration.parse(song_duration),
              song_duration?: true
            )
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
              "Value `7D` does not match the format of `duration` in `song_duration`"
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
              .required
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

    let(:song_duration) { "P7D" }

    it_behaves_like "check class info",
                    inputs: %i[song_duration],
                    internals: %i[song_duration],
                    outputs: %i[song_duration]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              song_duration: ActiveSupport::Duration.parse(song_duration),
              song_duration?: true
            )
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
              "Value `7D` does not match the format of `duration` in `song_duration`"
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
              .required
          )
        end
      end
    end
  end
end
