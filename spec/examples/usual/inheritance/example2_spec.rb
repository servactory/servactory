# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        api_identifier:,
        first_name:,
        middle_name:,
        last_name:,
        date:
      }
    end

    let(:api_identifier) { "First" }
    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:date) { DateTime.new(2023, 1, 1) }

    it_behaves_like "check class info",
                    inputs: %i[api_identifier date first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[api_response]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:api_identifier)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

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
            have_input(:date)
              .valid_with(attributes)
              .type(DateTime)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:api_response)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(
              :api_response,
              {
                api_identifier: "First",
                first_name: "John",
                middle_name: "Fitzgerald",
                last_name: "Kennedy",
                date: DateTime.new(2023, 1, 1)
              }
            )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        api_identifier:,
        first_name:,
        middle_name:,
        last_name:,
        date:
      }
    end

    let(:api_identifier) { "First" }
    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:date) { DateTime.new(2023, 1, 1) }

    it_behaves_like "check class info",
                    inputs: %i[api_identifier date first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[api_response]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:api_identifier)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

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
            have_input(:date)
              .valid_with(attributes)
              .type(DateTime)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:api_response)
              .instance_of(Hash)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(
              :api_response,
              {
                api_identifier: "First",
                first_name: "John",
                middle_name: "Fitzgerald",
                last_name: "Kennedy",
                date: DateTime.new(2023, 1, 1)
              }
            )
        )
      end
    end
  end
end
