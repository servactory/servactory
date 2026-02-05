# frozen_string_literal: true

require "async"
require "async/barrier"
require "async/semaphore"

RSpec.describe Usual::Async::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        id:,
        should_fail:
      }
    end

    let(:id) { 1 }
    let(:should_fail) { false }

    it_behaves_like "check class info",
                    inputs: %i[id should_fail],
                    internals: %i[],
                    outputs: %i[id]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:id)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:should_fail)
              .valid_with(attributes)
              .type([TrueClass, FalseClass])
              .optional
              .default(false)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:id)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:id, 1)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because should_fail is true" do
        let(:should_fail) { true }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Intentional failure for id=1")
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        id:,
        should_fail:
      }
    end

    let(:id) { 1 }
    let(:should_fail) { false }

    it_behaves_like "check class info",
                    inputs: %i[id should_fail],
                    internals: %i[],
                    outputs: %i[id]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:id)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:should_fail)
              .valid_with(attributes)
              .type([TrueClass, FalseClass])
              .optional
              .default(false)
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:id)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:id, 1)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because should_fail is true" do
        let(:should_fail) { true }

        it_behaves_like "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Intentional failure for id=1"
          )
        end
      end
    end

    describe "async with mixed success and failure" do
      let(:inputs) do
        (1..8).map do |id|
          { id: id, should_fail: id.odd? }
        end
      end

      it :aggregate_failures do
        service_results = Async do
          barrier = Async::Barrier.new
          semaphore = Async::Semaphore.new(10, parent: barrier)

          inputs.map do |attrs|
            semaphore.async { described_class.call(**attrs) }
          end.map(&:wait)
        ensure
          barrier.stop
        end.wait

        inputs.each_with_index do |attrs, i|
          result = service_results[i]

          if attrs[:should_fail]
            expect(result.failure?).to be(true)
            expect(result.error.message).to eq("Intentional failure for id=#{attrs[:id]}")
          else
            expect(result.success?).to be(true)
            expect(result.id).to eq(attrs[:id])
          end
        end
      end
    end
  end
end
