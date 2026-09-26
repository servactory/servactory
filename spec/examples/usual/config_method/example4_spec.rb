# frozen_string_literal: true

RSpec.describe Usual::ConfigMethod::Example4, type: :service do
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
      describe "when the url is cached" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:url, "https://cdn.example.com")
          )
        end
      end

      describe "when the url is not cached" do
        let(:host) { "other.example.com" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:url, "https://other.example.com")
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
      describe "when the url is cached" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:url, "https://cdn.example.com")
          )
        end
      end

      describe "when the url is not cached" do
        let(:host) { "other.example.com" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:url, "https://other.example.com")
          )
        end
      end
    end
  end
end
