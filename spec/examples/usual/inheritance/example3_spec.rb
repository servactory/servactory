# frozen_string_literal: true

RSpec.describe Usual::Inheritance::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        locale:
      }
    end

    let(:locale) { nil }

    it_behaves_like "check class info",
                    inputs: %i[locale],
                    internals: %i[code],
                    outputs: %i[code]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:locale)
              .valid_with(attributes)
              .type(String)
              .optional
              .default("de")
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:code)
              .type(Symbol)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:code)
              .instance_of(Symbol)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `locale` is not passed" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:code, :DE)
          )
        end
      end

      context "when `locale` is passed" do
        let(:locale) { "fr" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:code, :FR)
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        locale:
      }
    end

    let(:locale) { nil }

    it_behaves_like "check class info",
                    inputs: %i[locale],
                    internals: %i[code],
                    outputs: %i[code]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:locale)
              .valid_with(attributes)
              .type(String)
              .optional
              .default("de")
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:code)
              .type(Symbol)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:code)
              .instance_of(Symbol)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      context "when `locale` is not passed" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:code, :DE)
          )
        end
      end

      context "when `locale` is passed" do
        let(:locale) { "fr" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:code, :FR)
          )
        end
      end
    end
  end

  describe Usual::Inheritance::Example3Base do
    describe ".call!" do
      subject(:perform) { described_class.call!(**attributes) }

      let(:attributes) do
        {
          locale:
        }
      end

      let(:locale) { nil }

      it_behaves_like "check class info",
                      inputs: %i[locale],
                      internals: %i[code],
                      outputs: %i[code]

      describe "validations" do
        describe "inputs" do
          it do
            expect { perform }.to(
              have_input(:locale)
                .valid_with(attributes)
                .type(String)
                .optional
                .default("en")
            )
          end
        end

        describe "internals" do
          it do
            expect { perform }.to(
              have_internal(:code)
                .type(String)
            )
          end
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:code)
                .instance_of(String)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        context "when `locale` is not passed" do
          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:code, "EN")
            )
          end
        end

        context "when `locale` is passed" do
          let(:locale) { "fr" }

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:code, "FR")
            )
          end
        end
      end
    end

    describe ".call" do
      subject(:perform) { described_class.call(**attributes) }

      let(:attributes) do
        {
          locale:
        }
      end

      let(:locale) { nil }

      it_behaves_like "check class info",
                      inputs: %i[locale],
                      internals: %i[code],
                      outputs: %i[code]

      describe "validations" do
        describe "inputs" do
          it do
            expect { perform }.to(
              have_input(:locale)
                .valid_with(attributes)
                .type(String)
                .optional
                .default("en")
            )
          end
        end

        describe "internals" do
          it do
            expect { perform }.to(
              have_internal(:code)
                .type(String)
            )
          end
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:code)
                .instance_of(String)
            )
          end
        end
      end

      describe "and the data required for work is also valid" do
        context "when `locale` is not passed" do
          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:code, "EN")
            )
          end
        end

        context "when `locale` is passed" do
          let(:locale) { "fr" }

          it_behaves_like "success result class"

          it do
            expect(perform).to(
              be_success_service
                .with_output(:code, "FR")
            )
          end
        end
      end
    end
  end
end
