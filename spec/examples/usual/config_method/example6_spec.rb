# frozen_string_literal: true

RSpec.describe Usual::ConfigMethod::Example6, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        host:
      }
    end

    let(:host) { "example.com" }

    it_behaves_like "check class info",
                    inputs: %i[host],
                    internals: %i[],
                    outputs: %i[address]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:host)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:address)
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
            .with_output(:address, "192.0.2.1")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the host is unknown" do
        let(:host) { "unknown.example.com" }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Unknown host: unknown.example.com")
              expect(exception.meta).to(
                match(original_exception: be_an_instance_of(Usual::ConfigMethod::Example6::UnknownHostError))
              )
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        host:
      }
    end

    let(:host) { "example.com" }

    it_behaves_like "check class info",
                    inputs: %i[host],
                    internals: %i[],
                    outputs: %i[address]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:host)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:address)
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
            .with_output(:address, "192.0.2.1")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the host is unknown" do
        let(:host) { "unknown.example.com" }

        it_behaves_like "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Unknown host: unknown.example.com",
            meta: { original_exception: be_an_instance_of(Usual::ConfigMethod::Example6::UnknownHostError) }
          )
        end
      end
    end
  end
end
