# frozen_string_literal: true

RSpec.describe Usual::ConfigMethod::Example5, type: :service do
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
                    internals: %i[port],
                    outputs: %i[url]

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

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:port)
              .type(Integer)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:url)
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
            .with_output(:url, "https://example.com:443")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the port is reserved" do
        let(:host) { "ssh.example.com" }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Internal)
              expect(exception.internal_name).to eq(:port)
              expect(exception.message).to eq("Reserved port")
              expect(exception.meta).to match(port: 22)
            end
          )
        end
      end

      describe "because the url is too long" do
        let(:host) { "long-subdomain.example.com" }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Output)
              expect(exception.output_name).to eq(:url)
              expect(exception.message).to eq("URL is too long")
              expect(exception.meta).to match(url: "https://long-subdomain.example.com:443")
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
                    internals: %i[port],
                    outputs: %i[url]

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

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:port)
              .type(Integer)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:url)
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
            .with_output(:url, "https://example.com:443")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the port is reserved" do
        let(:host) { "ssh.example.com" }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Internal)
              expect(exception.internal_name).to eq(:port)
              expect(exception.message).to eq("Reserved port")
              expect(exception.meta).to match(port: 22)
            end
          )
        end
      end

      describe "because the url is too long" do
        let(:host) { "long-subdomain.example.com" }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Output)
              expect(exception.output_name).to eq(:url)
              expect(exception.message).to eq("URL is too long")
              expect(exception.meta).to match(url: "https://long-subdomain.example.com:443")
            end
          )
        end
      end
    end
  end
end
