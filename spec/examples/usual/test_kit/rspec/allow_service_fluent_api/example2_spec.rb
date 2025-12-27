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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "when child succeeds on first attempt" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
              .as_success
              .with_outputs(status: :completed, attempt_number: 1)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:completed) }
          it { expect(perform).to have_output(:total_attempts).contains(1) }
        end

        describe "when child succeeds on second attempt (sequential returns)" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
              .as_success
              .with_outputs(status: :processing, attempt_number: 1)
              .then_as_success
              .with_outputs(status: :completed, attempt_number: 2)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:completed) }
          it { expect(perform).to have_output(:total_attempts).contains(2) }
        end

        describe "when child never completes (all attempts return processing)" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
              .as_success
              .with_outputs(status: :processing, attempt_number: 1)
              .then_as_success
              .with_outputs(status: :processing, attempt_number: 2)
              .then_as_success
              .with_outputs(status: :processing, attempt_number: 3)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:processing) }
          it { expect(perform).to have_output(:total_attempts).contains(4) }
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

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        describe "when child succeeds on first attempt" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
              .as_success
              .with_outputs(status: :completed, attempt_number: 1)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:completed) }
        end

        describe "when child succeeds on second attempt (sequential returns)" do
          before do
            allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example2Child)
              .as_success
              .with_outputs(status: :processing, attempt_number: 1)
              .then_as_success
              .with_outputs(status: :completed, attempt_number: 2)
          end

          it_behaves_like "success result class"

          it { expect(perform).to have_output(:final_status).contains(:completed) }
        end
      end
    end
  end
end
