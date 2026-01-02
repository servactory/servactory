# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example6, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        user: {
          first_name:,
          middle_name:,
          last_name:,
          passport: {
            series:,
            number:
          }
        }
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:series) { "HR" }
    let(:number) { "88467617508" }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[payload full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(Hash)
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
          have_output(:payload)
            .contains(
              {
                request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                user: {
                  first_name: "John",
                  middle_name: "Fitzgerald",
                  last_name: "Kennedy",
                  passport: {
                    series: "HR",
                    number: "88467617508"
                  }
                }
              }
            )
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, "John Fitzgerald Kennedy")
        )
      end

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            have_output(:payload)
              .contains(
                {
                  request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  user: {
                    first_name: "John",
                    middle_name: nil,
                    last_name: "Kennedy",
                    passport: {
                      series: "HR",
                      number: "88467617508"
                    }
                  }
                }
              )
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:full_name, "John Kennedy")
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

    let(:payload) do
      {
        request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        user: {
          first_name:,
          middle_name:,
          last_name:,
          passport: {
            series:,
            number:
          }
        }
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:series) { "HR" }
    let(:number) { "88467617508" }

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[payload full_name]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .type(Hash)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:payload)
              .type(Hash)
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
          have_output(:payload)
            .contains(
              {
                request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                user: {
                  first_name: "John",
                  middle_name: "Fitzgerald",
                  last_name: "Kennedy",
                  passport: {
                    series: "HR",
                    number: "88467617508"
                  }
                }
              }
            )
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, "John Fitzgerald Kennedy")
        )
      end

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            have_output(:payload)
              .contains(
                {
                  request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  user: {
                    first_name: "John",
                    middle_name: nil,
                    last_name: "Kennedy",
                    passport: {
                      series: "HR",
                      number: "88467617508"
                    }
                  }
                }
              )
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:full_name, "John Kennedy")
          )
        end
      end
    end
  end
end
