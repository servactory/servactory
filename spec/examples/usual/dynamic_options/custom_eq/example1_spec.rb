# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::CustomEq::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { 2 }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[data],
                    outputs: [:data]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:data)
              .valid_with(attributes)
              .types(Integer, String, Array, Hash)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:data)
              .types(Integer, String, Array, Hash)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:data)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `data` is `Integer`" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, 2)
          )
        end
      end

      context "when `data` is `String`" do
        let(:data) { "Hi" }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, "Hi")
          )
        end
      end

      context "when `data` is `Array`" do
        let(:data) { [0, 1] }

        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.data?).to be(true)
          expect(result.data).to eq([0, 1])
        end
      end

      context "when `data` is `Hash`" do
        let(:data) { { a: 1, b: 2 } }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, { a: 1, b: 2 })
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      context "when `data` is `Integer`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { 1 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                  "received value `1`, which is not equivalent to `2`"
                )
              )
            end
          end
        end
      end

      context "when `data` is `String`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { "Data" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                  "received value `Data`, which is not equivalent to `2`"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Array`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { [0] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                  "received value `[0]`, which is not equivalent to `2`"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Hash`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { { a: 1 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                      "received value `{a: 1}`, which is not equivalent to `2`"
                  else
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                      "received value `{:a=>1}`, which is not equivalent to `2`"
                  end
                )
              )
            end
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { 2 }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[data],
                    outputs: [:data]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:data)
              .valid_with(attributes)
              .types(Integer, String, Array, Hash)
              .required
          )
        end
      end

      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:data)
              .types(Integer, String, Array, Hash)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:data)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `data` is `Integer`" do
        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, 2)
          )
        end
      end

      context "when `data` is `String`" do
        let(:data) { "Hi" }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, "Hi")
          )
        end
      end

      context "when `data` is `Array`" do
        let(:data) { [0, 1] }

        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.data?).to be(true)
          expect(result.data).to eq([0, 1])
        end
      end

      context "when `data` is `Hash`" do
        let(:data) { { a: 1, b: 2 } }

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, { a: 1, b: 2 })
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      context "when `data` is `Integer`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { 1 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                  "received value `1`, which is not equivalent to `2`"
                )
              )
            end
          end
        end
      end

      context "when `data` is `String`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { "Data" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                  "received value `Data`, which is not equivalent to `2`"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Array`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { [0] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                  "received value `[0]`, which is not equivalent to `2`"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Hash`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { { a: 1 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                      "received value `{a: 1}`, which is not equivalent to `2`"
                  else
                    "[Usual::DynamicOptions::CustomEq::Example1] Input attribute `data` " \
                      "received value `{:a=>1}`, which is not equivalent to `2`"
                  end
                )
              )
            end
          end
        end
      end
    end
  end
end
