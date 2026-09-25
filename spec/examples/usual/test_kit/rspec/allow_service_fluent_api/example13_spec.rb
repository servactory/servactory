# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example13, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example13Child }

  shared_examples "rejects unmatched inputs" do |method_name = :call|
    it "rejects inputs other than configured" do
      expect { child_service_class.public_send(method_name, amount: 200) }.to raise_error(
        RSpec::Mocks::MockExpectationError,
        /received :#{Regexp.escape(method_name.to_s)} with unexpected arguments/
      )
    end
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[total]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:total)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when with() is called before succeeds" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .succeeds(fee: 5)
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 105)
          )
        end
      end

      describe "when with() is called after succeeds" do
        before do
          allow_service(child_service_class)
            .succeeds(fee: 5)
            .with(amount: 100)
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 105)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "when with() is called before fails" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .fails(type: :base, message: "Fee unavailable")
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns expected error" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Failure, "Fee unavailable")
        end
      end

      describe "when with() is called after fails" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Fee unavailable")
            .with(amount: 100)
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns expected error" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Failure, "Fee unavailable")
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[total]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:total)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when with() is called before succeeds" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .succeeds(fee: 5)
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 105)
          )
        end
      end

      describe "when with() is called after succeeds" do
        before do
          allow_service(child_service_class)
            .succeeds(fee: 5)
            .with(amount: 100)
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 105)
          )
        end
      end

      describe "when with() is called before and_call_original" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .and_call_original
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 110)
          )
        end
      end

      describe "when with() is called after and_call_original" do
        before do
          allow_service(child_service_class)
            .and_call_original
            .with(amount: 100)
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 110)
          )
        end
      end

      describe "when with() is called before and_wrap_original" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .and_wrap_original do |original, **inputs|
              result = original.call(**inputs)
              Servactory::TestKit::Result.as_success(service_class: child_service_class, fee: result.fee + 1)
            end
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 111)
          )
        end
      end

      describe "when with() is called after and_wrap_original" do
        before do
          allow_service(child_service_class)
            .and_wrap_original do |original, **inputs|
              result = original.call(**inputs)
              Servactory::TestKit::Result.as_success(service_class: child_service_class, fee: result.fee + 1)
            end
            .with(amount: 100)
        end

        it_behaves_like "success result class"
        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total, 111)
          )
        end
      end

      describe "when with() is called before then_succeeds" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .succeeds(fee: 5)
            .then_succeeds(fee: 7)
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns sequential results" do
          totals = Array.new(2) { described_class.call(**attributes).total }

          expect(totals).to eq([105, 107])
        end
      end

      describe "when with() is called between succeeds and then_succeeds" do
        before do
          allow_service(child_service_class)
            .succeeds(fee: 5)
            .with(amount: 100)
            .then_succeeds(fee: 7)
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns sequential results" do
          totals = Array.new(2) { described_class.call(**attributes).total }

          expect(totals).to eq([105, 107])
        end
      end

      describe "when with() is called after then_succeeds" do
        before do
          allow_service(child_service_class)
            .succeeds(fee: 5)
            .then_succeeds(fee: 7)
            .with(amount: 100)
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns sequential results" do
          totals = Array.new(2) { described_class.call(**attributes).total }

          expect(totals).to eq([105, 107])
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "when with() is called before fails" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .fails(type: :base, message: "Fee unavailable")
        end

        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_failure_service
              .type(:base)
              .message("Fee unavailable")
          )
        end
      end

      describe "when with() is called after fails" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Fee unavailable")
            .with(amount: 100)
        end

        it_behaves_like "rejects unmatched inputs"

        it do
          expect(perform).to(
            be_failure_service
              .type(:base)
              .message("Fee unavailable")
          )
        end
      end

      describe "when with() is called before then_fails" do
        before do
          allow_service(child_service_class)
            .with(amount: 100)
            .succeeds(fee: 5)
            .then_fails(type: :base, message: "Fee unavailable")
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns sequential results", :aggregate_failures do
          expect(described_class.call(**attributes)).to be_success_service.with_output(:total, 105)
          expect(described_class.call(**attributes)).to be_failure_service.message("Fee unavailable")
        end
      end

      describe "when with() is called after then_fails" do
        before do
          allow_service(child_service_class)
            .succeeds(fee: 5)
            .then_fails(type: :base, message: "Fee unavailable")
            .with(amount: 100)
        end

        it_behaves_like "rejects unmatched inputs"

        it "returns sequential results", :aggregate_failures do
          expect(described_class.call(**attributes)).to be_success_service.with_output(:total, 105)
          expect(described_class.call(**attributes)).to be_failure_service.message("Fee unavailable")
        end
      end
    end
  end

  describe "mocking .call! of the child service" do
    describe "when with() is called before fails" do
      before do
        allow_service!(child_service_class)
          .with(amount: 100)
          .fails(type: :base, message: "Fee unavailable")
      end

      it_behaves_like "rejects unmatched inputs", :call!

      it "raises the configured failure for matching inputs" do
        expect { child_service_class.call!(amount: 100) }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Fee unavailable"
        )
      end
    end

    describe "when with() is called after fails" do
      before do
        allow_service!(child_service_class)
          .fails(type: :base, message: "Fee unavailable")
          .with(amount: 100)
      end

      it_behaves_like "rejects unmatched inputs", :call!

      it "raises the configured failure for matching inputs" do
        expect { child_service_class.call!(amount: 100) }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Fee unavailable"
        )
      end
    end

    describe "when with() is called after then_fails" do
      before do
        allow_service!(child_service_class)
          .succeeds(fee: 5)
          .then_fails(type: :base, message: "Fee unavailable")
          .with(amount: 100)
      end

      it_behaves_like "rejects unmatched inputs", :call!

      it "returns sequential results", :aggregate_failures do
        expect(child_service_class.call!(amount: 100).fee).to eq(5)
        expect { child_service_class.call!(amount: 100) }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Fee unavailable"
        )
      end
    end
  end
end
