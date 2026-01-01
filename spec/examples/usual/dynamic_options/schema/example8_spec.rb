# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::Example8, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      nil
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[payload full_name]

    describe "validations" do
      describe "inputs" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .types(Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true },
                    passport: {
                      type: Hash,
                      required: true,
                      series: { type: String, required: true },
                      number: { type: String, required: true }
                    },
                    session: {
                      type: Hash,
                      required: false,
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
              .optional
          )
        end
      end

      describe "internals" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_internal(:payload)
              .types(NilClass, Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true },
                    passport: {
                      type: Hash,
                      required: true,
                      series: { type: String, required: true },
                      number: { type: String, required: true }
                    },
                    session: {
                      type: Hash,
                      required: false,
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(NilClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(NilClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payload, nil)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, nil)
        )
      end

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, nil)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:full_name, nil)
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
      nil
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[payload],
                    outputs: %i[payload full_name]

    describe "validations" do
      describe "inputs" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_input(:payload)
              .valid_with(attributes)
              .types(Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true },
                    passport: {
                      type: Hash,
                      required: true,
                      series: { type: String, required: true },
                      number: { type: String, required: true }
                    },
                    session: {
                      type: Hash,
                      required: false,
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
              .optional
          )
        end
      end

      describe "internals" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_internal(:payload)
              .types(NilClass, Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true },
                    passport: {
                      type: Hash,
                      required: true,
                      series: { type: String, required: true },
                      number: { type: String, required: true }
                    },
                    session: {
                      type: Hash,
                      required: false,
                      default: {},
                      visited_on: { type: Date, required: false, default: nil }
                    }
                  }
                }
              )
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:payload)
              .instance_of(NilClass)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name)
              .instance_of(NilClass)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:payload, nil)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:full_name, nil)
        )
      end

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:payload, nil)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:full_name, nil)
          )
        end
      end
    end
  end
end
