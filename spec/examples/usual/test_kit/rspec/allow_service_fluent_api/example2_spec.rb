# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        max_attempts:
      }
    end

    let(:max_attempts) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[max_attempts],
                    internals: %i[],
                    outputs: %i[final_status total_attempts]
    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:final_status)
              .instance_of(Symbol)
          )
        end

        it do
          expect(perform).to(
            have_output(:total_attempts)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when child succeeds on first attempt" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
            .succeeds(status: :completed, attempt_number: 1)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:final_status, :completed)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total_attempts, 1)
          )
        end
      end

      describe "when child succeeds on second attempt (sequential returns)" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
            .succeeds(status: :processing, attempt_number: 1)
            .then_succeeds(status: :completed, attempt_number: 2)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:final_status, :completed)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total_attempts, 2)
          )
        end
      end

      describe "when child never completes (all attempts return processing)" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
            .succeeds(status: :processing, attempt_number: 1)
            .then_succeeds(status: :processing, attempt_number: 2)
            .then_succeeds(status: :processing, attempt_number: 3)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:final_status, :processing)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:total_attempts, 4)
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        max_attempts:
      }
    end

    let(:max_attempts) { 3 }

    it_behaves_like "check class info",
                    inputs: %i[max_attempts],
                    internals: %i[],
                    outputs: %i[final_status total_attempts]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:final_status)
              .instance_of(Symbol)
          )
        end

        it do
          expect(perform).to(
            have_output(:total_attempts)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "when child succeeds on first attempt" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
            .succeeds(status: :completed, attempt_number: 1)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:final_status, :completed)
          )
        end
      end

      describe "when child succeeds on second attempt (sequential returns)" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
            .succeeds(status: :processing, attempt_number: 1)
            .then_succeeds(status: :completed, attempt_number: 2)
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:final_status, :completed)
          )
        end
      end
    end
  end
end
