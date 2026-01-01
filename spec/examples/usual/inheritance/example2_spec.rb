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
  end
end
