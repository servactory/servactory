# frozen_string_literal: true

require "async"
require "async/barrier"
require "async/semaphore"

RSpec.describe Usual::Async::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        id: id
      }
    end

    let(:id) { 123 }

    include_examples "check class info",
                     inputs: %i[id],
                     internals: %i[],
                     outputs: %i[id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        describe "async" do
          ids = [1, 2, 3, 4]

          it :aggregate_failures do
            service_results = Async do
              barrier = Async::Barrier.new
              semaphore = Async::Semaphore.new(10, parent: barrier)

              ids.map do |id|
                semaphore.async { described_class.call!(id: id) }
              end.map(&:wait)
            ensure
              barrier.stop
            end.wait

            expect(service_results[0].id).to eq(1)
            expect(service_results[1].id).to eq(2)
            expect(service_results[2].id).to eq(3)
            expect(service_results[3].id).to eq(4)
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:id).direct(attributes).type(Integer).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        id: id
      }
    end

    let(:id) { 123 }

    include_examples "check class info",
                     inputs: %i[id],
                     internals: %i[],
                     outputs: %i[id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        describe "async" do
          ids = [1, 2, 3, 4]

          it :aggregate_failures do
            service_results = Async do
              barrier = Async::Barrier.new
              semaphore = Async::Semaphore.new(10, parent: barrier)

              ids.map do |id|
                semaphore.async { described_class.call(id: id) }
              end.map(&:wait)
            ensure
              barrier.stop
            end.wait

            expect(service_results[0].id).to eq(1)
            expect(service_results[1].id).to eq(2)
            expect(service_results[2].id).to eq(3)
            expect(service_results[3].id).to eq(4)
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:id).direct(attributes).type(Integer).required }
    end
  end
end
