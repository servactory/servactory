# frozen_string_literal: true

RSpec.describe Usual::ConfigMethod::Example3, type: :service do
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
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:url, "https://example.com")
        )
      end

      it "returns expected error", :aggregate_failures do
        expect { perform.url? }.to raise_error do |exception|
          expect(exception).to be_a(ApplicationService::Exceptions::Failure)
          expect(exception.type).to eq(:base)
          expect(exception.message).to(
            match(
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                /\[Usual::ConfigMethod::Example3\] undefined method 'url\?' for an instance of ApplicationService::Result/
              elsif Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
                /\[Usual::ConfigMethod::Example3\] undefined method `url\?' for an instance of ApplicationService::Result/
              else
                /\[Usual::ConfigMethod::Example3\] undefined method `url\?' for #<ApplicationService::Result/
              end
            )
          )
          expect(exception.meta).to match(original_exception: be_a(NoMethodError))
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
              "[Usual::ConfigMethod::Example3] Wrong type of input `host`, expected `String`, got `Integer`"
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
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:url, "https://example.com")
        )
      end

      it "returns expected error", :aggregate_failures do
        expect { perform.url? }.to raise_error do |exception|
          expect(exception).to be_a(ApplicationService::Exceptions::Failure)
          expect(exception.type).to eq(:base)
          expect(exception.message).to(
            match(
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                /\[Usual::ConfigMethod::Example3\] undefined method 'url\?' for an instance of ApplicationService::Result/
              elsif Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
                /\[Usual::ConfigMethod::Example3\] undefined method `url\?' for an instance of ApplicationService::Result/
              else
                /\[Usual::ConfigMethod::Example3\] undefined method `url\?' for #<ApplicationService::Result/
              end
            )
          )
          expect(exception.meta).to match(original_exception: be_a(NoMethodError))
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
              "[Usual::ConfigMethod::Example3] Wrong type of input `host`, expected `String`, got `Integer`"
            )
          )
        end
      end
    end
  end
end
