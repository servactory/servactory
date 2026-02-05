# frozen_string_literal: true

require "async"
require "async/barrier"
require "async/semaphore"

RSpec.describe Usual::Async::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[doubled tripled],
                    outputs: %i[result]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:result)
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
            .with_output(:result, 15)
        )
      end

      describe "async" do
        let(:numbers) { (1..10).to_a }

        it :aggregate_failures do
          service_results = Async do
            barrier = Async::Barrier.new
            semaphore = Async::Semaphore.new(10, parent: barrier)

            numbers.map do |n|
              semaphore.async { described_class.call!(number: n) }
            end.map(&:wait)
          ensure
            barrier.stop
          end.wait

          numbers.each_with_index do |n, i|
            expect(service_results[i].result).to eq(n * 5)
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[doubled tripled],
                    outputs: %i[result]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:number)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:result)
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
            .with_output(:result, 15)
        )
      end

      describe "async" do
        let(:numbers) { (1..10).to_a }

        it :aggregate_failures do
          service_results = Async do
            barrier = Async::Barrier.new
            semaphore = Async::Semaphore.new(10, parent: barrier)

            numbers.map do |n|
              semaphore.async { described_class.call(number: n) }
            end.map(&:wait)
          ensure
            barrier.stop
          end.wait

          numbers.each_with_index do |n, i|
            expect(service_results[i].result).to eq(n * 5)
          end
        end
      end
    end
  end
end
