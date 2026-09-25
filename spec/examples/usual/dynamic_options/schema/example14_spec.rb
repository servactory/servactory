# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example14, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) { { name: "John" } }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[payload]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  name: { type: String },
                  settings: {
                    type: Hash,
                    required: false,
                    default: { notifications: {} },
                    lang: { type: String, required: false, default: "en" },
                    notifications: { type: Hash, channel: { type: String, required: false, default: "email" } }
                  }
                }
              )
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `settings` is not passed" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(
                :payload,
                { name: "John", settings: { lang: "en", notifications: { channel: "email" } } }
              )
          )
        end

        it "does not modify the default" do
          2.times { described_class.call!(**attributes) }

          expect(described_class::SETTINGS_DEFAULT).to eq({ notifications: {} })
        end

        it "returns independent values for consecutive calls" do
          first_payload = perform.payload
          first_payload[:settings][:notifications][:channel] = "sms"

          expect(described_class.call!(payload: { name: "Jane" })).to(
            be_success_service
              .with_output(
                :payload,
                { name: "Jane", settings: { lang: "en", notifications: { channel: "email" } } }
              )
          )
        end
      end

      context "when `settings` is passed" do
        let(:payload) { { name: "John", settings: { lang: "ru", notifications: {} } } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(
                :payload,
                { name: "John", settings: { lang: "ru", notifications: { channel: "email" } } }
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
        payload:
      }
    end

    let(:payload) { { name: "John" } }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[payload]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .schema(
                {
                  name: { type: String },
                  settings: {
                    type: Hash,
                    required: false,
                    default: { notifications: {} },
                    lang: { type: String, required: false, default: "en" },
                    notifications: { type: Hash, channel: { type: String, required: false, default: "email" } }
                  }
                }
              )
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `settings` is not passed" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(
                :payload,
                { name: "John", settings: { lang: "en", notifications: { channel: "email" } } }
              )
          )
        end

        it "does not modify the default" do
          2.times { described_class.call(**attributes) }

          expect(described_class::SETTINGS_DEFAULT).to eq({ notifications: {} })
        end

        it "returns independent values for consecutive calls" do
          first_payload = perform.payload
          first_payload[:settings][:notifications][:channel] = "sms"

          expect(described_class.call(payload: { name: "Jane" })).to(
            be_success_service
              .with_output(
                :payload,
                { name: "Jane", settings: { lang: "en", notifications: { channel: "email" } } }
              )
          )
        end
      end

      context "when `settings` is passed" do
        let(:payload) { { name: "John", settings: { lang: "ru", notifications: {} } } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(
                :payload,
                { name: "John", settings: { lang: "ru", notifications: { channel: "email" } } }
              )
          )
        end
      end
    end
  end
end
