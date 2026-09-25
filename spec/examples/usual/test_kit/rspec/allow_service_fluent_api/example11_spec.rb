# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceFluentApi::Example11, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[entries_count]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:entries_count)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "with no_inputs matcher for a service with only optional inputs" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example11Child)
            .with(no_inputs)
            .succeeds(entries: %w[first second])
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:entries_count, 2)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example11Child)
            .with(no_inputs)
            .fails(type: :base, message: "Entries unavailable")
        end

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Entries unavailable")
              expect(exception.meta).to be_nil
            end
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[entries_count]

    describe "validations" do
      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:entries_count)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      describe "with no_inputs matcher for a service with only optional inputs" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example11Child)
            .with(no_inputs)
            .succeeds(entries: %w[first second third])
        end

        it_behaves_like "success result class"

        it do
          expect(perform).to(
            be_success_service
              .with_output(:entries_count, 3)
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      describe "because child service fails" do
        before do
          allow_service(Usual::TestKit::Rspec::AllowServiceFluentApi::Example11Child)
            .with(no_inputs)
            .fails(type: :base, message: "Entries unavailable")
        end

        it "returns expected error", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Entries unavailable",
            meta: nil
          )
        end
      end
    end
  end
end
