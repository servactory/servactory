# frozen_string_literal: true

RSpec.describe Usual::ConfigMethod::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        host:,
        secure:
      }
    end

    let(:host) { "example.com" }
    let(:secure) { true }

    it_behaves_like "check class info",
                    inputs: %i[host secure],
                    internals: %i[port],
                    outputs: %i[url secure]

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

        it do
          expect { perform }.to(
            have_input(:secure)
              .valid_with(attributes)
              .types(TrueClass, FalseClass)
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

        it do
          expect(perform).to(
            have_output(:secure)
              .instance_of(TrueClass)
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
              url: "https://example.com:443",
              secure: true
            )
        )
      end

      it "returns expected predicate values", :aggregate_failures do
        expect(perform.url?).to be(true)
        expect(perform.secure?).to be(true)
      end

      describe "when the connection is not secure" do
        let(:secure) { false }

        it do
          expect(perform).to(
            be_success_service
              .with_outputs(
                url: "http://example.com:80",
                secure: false
              )
          )
        end

        it "returns expected predicate values", :aggregate_failures do
          expect(perform.url?).to be(true)
          expect(perform.secure?).to be(false)
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `host` has the wrong type" do
        let(:host) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::ConfigMethod::Example1] Wrong type of input `host`, expected `String`, got `Integer`"
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
        host:,
        secure:
      }
    end

    let(:host) { "example.com" }
    let(:secure) { true }

    it_behaves_like "check class info",
                    inputs: %i[host secure],
                    internals: %i[port],
                    outputs: %i[url secure]

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

        it do
          expect { perform }.to(
            have_input(:secure)
              .valid_with(attributes)
              .types(TrueClass, FalseClass)
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

        it do
          expect(perform).to(
            have_output(:secure)
              .instance_of(TrueClass)
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
              url: "https://example.com:443",
              secure: true
            )
        )
      end

      it "returns expected predicate values", :aggregate_failures do
        expect(perform.url?).to be(true)
        expect(perform.secure?).to be(true)
      end

      describe "when the connection is not secure" do
        let(:secure) { false }

        it do
          expect(perform).to(
            be_success_service
              .with_outputs(
                url: "http://example.com:80",
                secure: false
              )
          )
        end

        it "returns expected predicate values", :aggregate_failures do
          expect(perform.url?).to be(true)
          expect(perform.secure?).to be(false)
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because `host` has the wrong type" do
        let(:host) { 123 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::ConfigMethod::Example1] Wrong type of input `host`, expected `String`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
