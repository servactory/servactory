# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example19, type: :service do
  let(:child_service_class) { Usual::TestKit::Rspec::AllowServiceFluentApi::Example19Child }

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
                    outputs: %i[price]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:price)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds" do
        before do
          allow_service(child_service_class)
            .succeeds(discount: 10)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:price, 90)
          )
        end
      end

      describe "when using and_call_original" do
        before do
          allow_service(child_service_class)
            .and_call_original
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:price, 95)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Discount unavailable")
        end

        it "returns expected error" do
          expect { perform }.to raise_error(ApplicationService::Exceptions::Failure, "Discount unavailable")
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
                    outputs: %i[price]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:price)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when using succeeds" do
        before do
          allow_service(child_service_class)
            .succeeds(discount: 10)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:price, 90)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(child_service_class)
            .fails(type: :base, message: "Discount unavailable")
        end

        it do
          expect(perform).to(
            be_failure_service
              .type(:base)
              .message("Discount unavailable")
          )
        end
      end
    end
  end

  describe "reconfiguration of the child service mock after it was called" do
    def price_for(amount)
      described_class.call!(amount:).price
    end

    context "when with() is called" do
      let!(:mock) { allow_service(child_service_class).succeeds(discount: 10) }

      before do
        price_for(100)
      end

      it "applies the input matching to the following calls" do
        mock.with(amount: 200).succeeds(discount: 50)

        expect(price_for(200)).to eq(150)
      end

      it "keeps answering other calls with the earlier configuration" do
        mock.with(amount: 200).succeeds(discount: 50)

        expect(price_for(100)).to eq(90)
      end
    end

    context "when succeeds is called" do
      let!(:mock) { allow_service(child_service_class).succeeds(discount: 10) }

      before do
        price_for(100)
      end

      it "returns the new outputs" do
        mock.succeeds(discount: 30)

        expect(price_for(100)).to eq(70)
      end
    end

    context "when fails is called" do
      let!(:mock) { allow_service(child_service_class).fails(type: :base, message: "Discount unavailable") }

      before do
        described_class.call(amount: 100)
      end

      it "returns the new failure" do
        mock.fails(type: :base, message: "Discount expired")

        expect(described_class.call(amount: 100)).to(
          be_failure_service
            .type(:base)
            .message("Discount expired")
        )
      end
    end

    context "when then_succeeds is called" do
      let!(:mock) { allow_service(child_service_class).succeeds(discount: 10) }

      before do
        price_for(100)
      end

      it "returns sequential results from the first one" do
        mock.then_succeeds(discount: 20)

        expect(Array.new(3) { price_for(100) }).to eq([90, 80, 80])
      end
    end

    context "when then_fails is called" do
      let!(:mock) { allow_service(child_service_class).succeeds(discount: 10) }

      before do
        price_for(100)
      end

      it "returns sequential results from the first one", :aggregate_failures do
        mock.then_fails(type: :base, message: "Discount unavailable")

        expect(described_class.call(amount: 100)).to be_success_service.with_output(:price, 90)
        expect(described_class.call(amount: 100)).to be_failure_service.message("Discount unavailable")
      end
    end

    context "when then_fails is called for call!" do
      let!(:mock) { allow_service!(child_service_class).succeeds(discount: 10) }

      before do
        child_service_class.call!(amount: 100)
      end

      it "returns sequential results from the first one", :aggregate_failures do
        mock.then_fails(type: :base, message: "Discount unavailable")

        expect(child_service_class.call!(amount: 100).discount).to eq(10)
        expect { child_service_class.call!(amount: 100) }.to raise_error(
          ApplicationService::Exceptions::Failure,
          "Discount unavailable"
        )
      end
    end

    context "when with() is called after and_call_original" do
      let!(:mock) { allow_service(child_service_class).and_call_original }

      before do
        price_for(100)
      end

      it "passes the matching calls through to the original" do
        mock.with(amount: 200)

        expect(price_for(200)).to eq(190)
      end
    end

    context "when with() is called after and_wrap_original" do
      let!(:mock) do
        allow_service(child_service_class).and_wrap_original do |original, **inputs|
          original.call(amount: inputs.fetch(:amount) * 2)
        end
      end

      before do
        price_for(100)
      end

      it "passes the matching calls through to the wrap block" do
        mock.with(amount: 200)

        expect(price_for(200)).to eq(180)
      end
    end

    context "when the mock was not called yet" do
      let!(:mock) { allow_service(child_service_class).succeeds(discount: 10) }

      it "reconfigures the mock in place" do
        mock.with(amount: 200)

        expect { price_for(100) }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /received :call with unexpected arguments/
        )
      end
    end
  end
end
