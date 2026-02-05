# frozen_string_literal: true

require "async"
require "async/barrier"
require "async/semaphore"

RSpec.describe Usual::Async::Example5, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        index:
      }
    end

    let(:index) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[index],
                    internals: %i[computed],
                    outputs: %i[value]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:index)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:value)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:value, "result-1")
        )
      end

      describe "async stress test" do
        let(:count) { 50 }

        it :aggregate_failures do
          service_results = Async do
            barrier = Async::Barrier.new
            semaphore = Async::Semaphore.new(20, parent: barrier)

            (1..count).map do |i|
              semaphore.async { described_class.call!(index: i) }
            end.map(&:wait)
          ensure
            barrier.stop
          end.wait

          values = service_results.map(&:value)

          (1..count).each do |i|
            expect(service_results[i - 1].value).to eq("result-#{i}")
          end

          expect(values.uniq.size).to eq(count)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        index:
      }
    end

    let(:index) { 1 }

    it_behaves_like "check class info",
                    inputs: %i[index],
                    internals: %i[computed],
                    outputs: %i[value]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:index)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:value)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:value, "result-1")
        )
      end

      describe "async stress test" do
        let(:count) { 50 }

        it :aggregate_failures do
          service_results = Async do
            barrier = Async::Barrier.new
            semaphore = Async::Semaphore.new(20, parent: barrier)

            (1..count).map do |i|
              semaphore.async { described_class.call(index: i) }
            end.map(&:wait)
          ensure
            barrier.stop
          end.wait

          values = service_results.map(&:value)

          (1..count).each do |i|
            expect(service_results[i - 1].value).to eq("result-#{i}")
          end

          expect(values.uniq.size).to eq(count)
        end
      end
    end
  end
end
