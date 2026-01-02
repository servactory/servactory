# frozen_string_literal: true

RSpec.describe Wrong::Prepare::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        balance_cents:
      }
    end

    let(:balance_cents) { 2_000_00 }

    it_behaves_like "check class info",
                    inputs: %i[balance_cents],
                    internals: %i[],
                    outputs: %i[balance_with_bonus]

    describe "but the data required for work is invalid" do
      it "returns expected error", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(NoMethodError)
            expect(exception.message).to(
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                eq("undefined method '+' for nil")
              else
                match(/undefined method `\+' for nil|:NilClass/)
              end
            )
          end
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it "returns expected inputs", :aggregate_failures do
          expect { perform }.to have_input(:balance_cents).valid_with(attributes).type(Integer).required
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:balance_with_bonus)
                .instance_of(String)
            )
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        balance_cents:
      }
    end

    let(:balance_cents) { 2_000_00 }

    it_behaves_like "check class info",
                    inputs: %i[balance_cents],
                    internals: %i[],
                    outputs: %i[balance_with_bonus]

    describe "but the data required for work is invalid" do
      it "returns expected error", :aggregate_failures do
        expect { perform }.to(
          raise_error do |exception|
            expect(exception).to be_a(NoMethodError)
            expect(exception.message).to(
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                eq("undefined method '+' for nil")
              else
                match(/undefined method `\+' for nil|:NilClass/)
              end
            )
          end
        )
      end
    end

    describe "validations" do
      describe "inputs" do
        it "returns expected inputs", :aggregate_failures do
          expect { perform }.to have_input(:balance_cents).valid_with(attributes).type(Integer).required
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:balance_with_bonus)
                .instance_of(String)
            )
          end
        end
      end
    end
  end
end
