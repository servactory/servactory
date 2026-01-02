# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Inclusion::Example19, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        digit:
      }
    end

    let(:digit) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[digit],
                    internals: %i[],
                    outputs: %i[digit]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:digit, 5)
        )
      end
    end

    describe "and the value is at the lower boundary" do
      let(:digit) { 1 }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:digit, 1)
        )
      end
    end

    describe "and the value is just below upper boundary" do
      let(:digit) { 9 }

      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:digit, 9)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `digit` equals excluded end" do
        let(:digit) { 10 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example19] Wrong value in `digit`, " \
              "must be one of `1...10`, " \
              "got `10`"
            )
          )
        end
      end

      describe "because the value of `digit` is below range" do
        let(:digit) { 0 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example19] Wrong value in `digit`, " \
              "must be one of `1...10`, " \
              "got `0`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:digit)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(1...10)
          )
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:digit)
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
        digit:
      }
    end

    let(:digit) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[digit],
                    internals: %i[],
                    outputs: %i[digit]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:digit, 5)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the value of `digit` equals excluded end" do
        let(:digit) { 10 }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Inclusion::Example19] Wrong value in `digit`, " \
              "must be one of `1...10`, " \
              "got `10`"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:digit)
              .valid_with(attributes)
              .type(Integer)
              .required
              .inclusion(1...10)
          )
        end

        describe "outputs" do
          it do
            expect(perform).to(
              have_output(:digit)
                .instance_of(Integer)
            )
          end
        end
      end
    end
  end
end
