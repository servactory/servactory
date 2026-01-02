# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::DateTime::Message::Static::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        started_at:
      }
    end

    let(:started_at) { "2023-04-14 8:58" }

    it_behaves_like "check class info",
                    inputs: %i[started_at],
                    internals: %i[started_at],
                    outputs: %i[started_at]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:started_at)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:started_at)
              .instance_of(DateTime)
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
              started_at: DateTime.parse(started_at),
              started_at?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `date_time`" do
        let(:started_at) { "2023-04-14 26:70" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Invalid datetime format"
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
        started_at:
      }
    end

    let(:started_at) { "2023-04-14 8:58" }

    it_behaves_like "check class info",
                    inputs: %i[started_at],
                    internals: %i[started_at],
                    outputs: %i[started_at]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:started_at)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:started_at)
              .instance_of(DateTime)
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
              started_at: DateTime.parse(started_at),
              started_at?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `date_time`" do
        let(:started_at) { "2023-04-14 26:70" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Invalid datetime format"
            )
          )
        end
      end
    end
  end
end
