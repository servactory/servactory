# frozen_string_literal: true

RSpec.describe Wrong::Basic::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          result = perform

          expect { result.fake_value }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to(
                match(
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    /\[Wrong::Basic::Example10\] undefined method 'fake_value' for #<ApplicationService::Result(.*)>/
                  else
                    /\[Wrong::Basic::Example10\] undefined method `fake_value' for #<ApplicationService::Result(.*)>/
                  end
                )
              )
              expect(exception.meta).to match(original_exception: be_an_instance_of(NoMethodError))
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[value]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          result = perform

          expect { result.fake_value }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to(
                match(
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    /\[Wrong::Basic::Example10\] undefined method 'fake_value' for #<ApplicationService::Result(.*)>/
                  else
                    /\[Wrong::Basic::Example10\] undefined method `fake_value' for #<ApplicationService::Result(.*)>/
                  end
                )
              )
              expect(exception.meta).to match(original_exception: be_an_instance_of(NoMethodError))
            end
          )
        end
      end
    end
  end
end
