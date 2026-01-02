# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Min::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { 10 }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[data],
                    outputs: [:data]

    describe "and the data required for work is also valid" do
      context "when `data` is `Integer`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, 10)
          )
        end
      end

      context "when `data` is `String`" do
        let(:data) { "Sesquipedalianism" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, "Sesquipedalianism")
          )
        end
      end

      context "when `data` is `Array`" do
        let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
          )
        end
      end

      context "when `data` is `Hash`" do
        let(:data) { { a: 1, b: 2, c: 3, d: 4 } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, { a: 1, b: 2, c: 3, d: 4 })
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      context "when `data` is `Integer`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { 0 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be greater than or equal to `1` (got: `0`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { 1 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be greater than or equal to `2` (got: `1`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { 2 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be greater than or equal to `3` (got: `2`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `String`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { "" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { "S" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be greater than or equal to `2` (got: `S`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { "Se" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be greater than or equal to `3` (got: `Se`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Array`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { [] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { [0] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be greater than or equal to `2` (got: `[0]`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { [1, 2] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be greater than or equal to `3` (got: `[1, 2]`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Hash`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { {} }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { { a: 1 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be greater than or equal to `2` (got: `{a: 1}`)"
                  else
                    "The size of the `data` value must be greater than or equal to `2` (got: `{:a=>1}`)"
                  end
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { { a: 1, b: 2 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be greater than or equal to `3` (got: `{a: 1, b: 2}`)"
                  else
                    "The size of the `data` value must be greater than or equal to `3` (got: `{:a=>1, :b=>2}`)"
                  end
                )
              )
            end
          end
        end
      end
    end

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

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:data)
                .instance_of(Integer)
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
        data:
      }
    end

    let(:data) { 10 }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[data],
                    outputs: [:data]

    describe "and the data required for work is also valid" do
      context "when `data` is `Integer`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, 10)
          )
        end
      end

      context "when `data` is `String`" do
        let(:data) { "Sesquipedalianism" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, "Sesquipedalianism")
          )
        end
      end

      context "when `data` is `Array`" do
        let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
          )
        end
      end

      context "when `data` is `Hash`" do
        let(:data) { { a: 1, b: 2, c: 3, d: 4 } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, { a: 1, b: 2, c: 3, d: 4 })
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      context "when `data` is `Integer`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { 0 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be greater than or equal to `1` (got: `0`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { 1 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be greater than or equal to `2` (got: `1`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { 2 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be greater than or equal to `3` (got: `2`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `String`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { "" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { "S" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be greater than or equal to `2` (got: `S`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { "Se" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be greater than or equal to `3` (got: `Se`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Array`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { [] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { [0] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be greater than or equal to `2` (got: `[0]`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { [1, 2] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be greater than or equal to `3` (got: `[1, 2]`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Hash`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { {} }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "[Usual::DynamicOptions::Min::Example2] Required input `data` is missing"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { { a: 1 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be greater than or equal to `2` (got: `{a: 1}`)"
                  else
                    "The size of the `data` value must be greater than or equal to `2` (got: `{:a=>1}`)"
                  end
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { { a: 1, b: 2 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be greater than or equal to `3` (got: `{a: 1, b: 2}`)"
                  else
                    "The size of the `data` value must be greater than or equal to `3` (got: `{:a=>1, :b=>2}`)"
                  end
                )
              )
            end
          end
        end
      end
    end

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

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:data)
                .instance_of(Integer)
            )
          end
        end
      end
    end
  end
end
