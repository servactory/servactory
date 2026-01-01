# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Max::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[data],
                    outputs: [:data]

    describe "and the data required for work is also valid" do
      context "when `data` is `Integer`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, 1)
          )
        end
      end

      context "when `data` is `String`" do
        let(:data) { "Data" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, "Data")
          )
        end
      end

      context "when `data` is `Array`" do
        let(:data) { [0] }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, [0])
          )
        end
      end

      context "when `data` is `Hash`" do
        let(:data) { { a: 1 } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, { a: 1 })
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      context "when `data` is `Integer`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { 11 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be less than or equal to `10` (got: `11`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { 10 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be less than or equal to `9` (got: `10`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { 9 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be less than or equal to `8` (got: `9`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `String`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { "Sesquipedalianism" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be less than or equal to `10` (got: `Sesquipedalianism`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { "Alexandria" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be less than or equal to `9` (got: `Alexandria`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { "Strengths" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be less than or equal to `8` (got: `Strengths`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Array`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be less than or " \
                  "equal to `10` (got: `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be less than or " \
                  "equal to `9` (got: `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be less than or " \
                  "equal to `8` (got: `[0, 1, 2, 3, 4, 5, 6, 7, 8]`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Hash`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be less than or equal to `10` " \
                      "(got: `{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11}`)"
                  else
                    "The size of the `data` value must be less than or equal to `10` " \
                      "(got: `{:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9, :j=>10, :k=>11}`)"
                  end
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be less than or equal to `9` " \
                      "(got: `{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10}`)"
                  else
                    "The size of the `data` value must be less than or equal to `9` " \
                      "(got: `{:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9, :j=>10}`)"
                  end
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be less than or equal to `8` " \
                      "(got: `{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9}`)"
                  else
                    "The size of the `data` value must be less than or equal to `8` " \
                      "(got: `{:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9}`)"
                  end
                )
              )
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:data).valid_with(attributes).types(Integer, String, Array, Hash).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        data:
      }
    end

    let(:data) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[data],
                    internals: %i[data],
                    outputs: [:data]

    describe "and the data required for work is also valid" do
      context "when `data` is `Integer`" do
        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, 1)
          )
        end
      end

      context "when `data` is `String`" do
        let(:data) { "Data" }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, "Data")
          )
        end
      end

      context "when `data` is `Array`" do
        let(:data) { [0] }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, [0])
          )
        end
      end

      context "when `data` is `Hash`" do
        let(:data) { { a: 1 } }

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            have_output(:data?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:data, { a: 1 })
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      context "when `data` is `Integer`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { 11 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be less than or equal to `10` (got: `11`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { 10 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be less than or equal to `9` (got: `10`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { 9 }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be less than or equal to `8` (got: `9`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `String`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { "Sesquipedalianism" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be less than or equal to `10` (got: `Sesquipedalianism`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { "Alexandria" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be less than or equal to `9` (got: `Alexandria`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { "Strengths" }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be less than or equal to `8` (got: `Strengths`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Array`" do
        describe "because the value is greater than specified" do
          describe "for `input` attribute" do
            let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  "The size of the `data` value must be less than or " \
                  "equal to `10` (got: `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`)"
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  "The size of the `data` value must be less than or " \
                  "equal to `9` (got: `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`)"
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { [0, 1, 2, 3, 4, 5, 6, 7, 8] }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  "The size of the `data` value must be less than or " \
                  "equal to `8` (got: `[0, 1, 2, 3, 4, 5, 6, 7, 8]`)"
                )
              )
            end
          end
        end
      end

      context "when `data` is `Hash`" do
        describe "because the value is less than specified" do
          describe "for `input` attribute" do
            let(:data) { { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Input,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be less than or equal to `10` " \
                      "(got: `{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11}`)"
                  else
                    "The size of the `data` value must be less than or equal to `10` " \
                      "(got: `{:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9, :j=>10, :k=>11}`)"
                  end
                )
              )
            end
          end

          describe "for `internal` attribute" do
            let(:data) { { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Internal,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be less than or equal to `9` " \
                      "(got: `{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10}`)"
                  else
                    "The size of the `data` value must be less than or equal to `9` " \
                      "(got: `{:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9, :j=>10}`)"
                  end
                )
              )
            end
          end

          describe "for `output` attribute" do
            let(:data) { { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9 } }

            it "returns expected error" do
              expect { perform }.to(
                raise_error(
                  ApplicationService::Exceptions::Output,
                  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
                    "The size of the `data` value must be less than or equal to `8` " \
                      "(got: `{a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9}`)"
                  else
                    "The size of the `data` value must be less than or equal to `8` " \
                      "(got: `{:a=>1, :b=>2, :c=>3, :d=>4, :e=>5, :f=>6, :g=>7, :h=>8, :i=>9}`)"
                  end
                )
              )
            end
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:data).valid_with(attributes).types(Integer, String, Array, Hash).required }
    end
  end
end
