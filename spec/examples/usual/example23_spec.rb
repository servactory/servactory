# frozen_string_literal: true

RSpec.describe Usual::Example23 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        api_identifier: api_identifier,
        first_name: first_name,
        middle_name: middle_name,
        last_name: last_name,
        date: date
      }
    end

    let(:api_identifier) { "First" }
    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }
    let(:date) { DateTime.new(2023, 1, 1) }

    context "when the input arguments are invalid" do
      context "when `elma_identifier`" do
        it_behaves_like "input required check", name: :elma_identifier
        it_behaves_like "input type check", name: :elma_identifier, expected_type: String
      end

      context "when `first_name`" do
        it_behaves_like "input required check", name: :first_name
        it_behaves_like "input type check", name: :first_name, expected_type: String
      end

      context "when `middle_name`" do
        it_behaves_like "input required check", name: :middle_name
        it_behaves_like "input type check", name: :middle_name, expected_type: String
      end

      context "when `last_name`" do
        it_behaves_like "input required check", name: :last_name
        it_behaves_like "input type check", name: :last_name, expected_type: String
      end

      context "when `verification_date`" do
        it_behaves_like "input required check", name: :verification_date
        it_behaves_like "input type check", name: :verification_date, expected_type: DateTime
      end
    end
  end
end
