# frozen_string_literal: true

require "async"
require "async/barrier"
require "async/semaphore"

RSpec.describe Usual::Async::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:last_name) { "Doe" }

    it_behaves_like "check class info",
                    inputs: %i[first_name last_name],
                    internals: %i[full_name],
                    outputs: %i[greeting]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
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
            .with_output(:greeting, "Hello, John Doe!")
        )
      end

      describe "async" do
        let(:names) do
          [
            { first_name: "Alice", last_name: "Smith" },
            { first_name: "Bob", last_name: "Jones" },
            { first_name: "Charlie", last_name: "Brown" },
            { first_name: "Diana", last_name: "Prince" },
            { first_name: "Eve", last_name: "Adams" },
            { first_name: "Frank", last_name: "Castle" }
          ]
        end

        it :aggregate_failures do
          service_results = Async do
            barrier = Async::Barrier.new
            semaphore = Async::Semaphore.new(10, parent: barrier)

            names.map do |name|
              semaphore.async { described_class.call!(**name) }
            end.map(&:wait)
          ensure
            barrier.stop
          end.wait

          names.each_with_index do |name, i|
            expect(service_results[i].greeting).to eq("Hello, #{name[:first_name]} #{name[:last_name]}!")
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:last_name) { "Doe" }

    it_behaves_like "check class info",
                    inputs: %i[first_name last_name],
                    internals: %i[full_name],
                    outputs: %i[greeting]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:first_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end

        it do
          expect { perform }.to(
            have_input(:last_name)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:greeting)
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
            .with_output(:greeting, "Hello, John Doe!")
        )
      end

      describe "async" do
        let(:names) do
          [
            { first_name: "Alice", last_name: "Smith" },
            { first_name: "Bob", last_name: "Jones" },
            { first_name: "Charlie", last_name: "Brown" },
            { first_name: "Diana", last_name: "Prince" },
            { first_name: "Eve", last_name: "Adams" },
            { first_name: "Frank", last_name: "Castle" }
          ]
        end

        it :aggregate_failures do
          service_results = Async do
            barrier = Async::Barrier.new
            semaphore = Async::Semaphore.new(10, parent: barrier)

            names.map do |name|
              semaphore.async { described_class.call(**name) }
            end.map(&:wait)
          ensure
            barrier.stop
          end.wait

          names.each_with_index do |name, i|
            expect(service_results[i].greeting).to eq("Hello, #{name[:first_name]} #{name[:last_name]}!")
          end
        end
      end
    end
  end
end
