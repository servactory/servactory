# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::Matchers::ProcMessageKeywordsService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        count: 1,
        status: :active,
        ids: [1, 2],
        config: { key: "value" },
        handler: described_class::Handler
      }
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:count)
              .type(Integer)
              .message('[ProcMessageKeywordsService] `count`: [nil, "Integer", nil]')
          )
        end

        it do
          expect { perform }.to(
            have_input(:status)
              .type(Symbol)
              .inclusion(%i[active inactive])
              .message(
                "[ProcMessageKeywordsService] `status`: [nil, :be_inclusion, nil, :inclusion, [:active, :inactive]]"
              )
          )
        end

        it do
          expect { perform }.to(
            have_input(:ids)
              .type(Array)
              .consists_of(Integer)
              .message("[ProcMessageKeywordsService] `ids`: [nil, :consists_of, nil, :consists_of, Integer]")
          )
        end

        it do
          expect { perform }.to(
            have_input(:config)
              .type(Hash)
              .schema({ key: { type: String } })
              .message(
                "[ProcMessageKeywordsService] `config`: [NilClass, :schema, nil, :schema, [:key], nil, nil, nil]"
              )
          )
        end

        it do
          expect { perform }.to(
            have_input(:handler)
              .type(Class)
              .target([described_class::Handler])
              .message(
                "[ProcMessageKeywordsService] `handler`: [nil, :be_target, nil, :target, " \
                "[Usual::TestKit::Rspec::Matchers::ProcMessageKeywordsService::Handler]]"
              )
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it { expect(perform).to be_success_service }
    end

    describe "but the data required for work is invalid" do
      describe "because of the type" do
        before { attributes[:count] = "1" }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            '[ProcMessageKeywordsService] `count`: ["1", "Integer", "String"]'
          )
        end
      end

      describe "because of the inclusion" do
        before { attributes[:status] = :unknown }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[ProcMessageKeywordsService] `status`: [:unknown, :be_inclusion, nil, :inclusion, [:active, :inactive]]"
          )
        end
      end

      describe "because of the consists_of" do
        before { attributes[:ids] = ["1"] }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            '[ProcMessageKeywordsService] `ids`: [["1"], :consists_of, :wrong_element_type, :consists_of, Integer]'
          )
        end
      end

      describe "because of the schema" do
        before { attributes[:config] = { key: 1 } }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[ProcMessageKeywordsService] `config`: " \
            '[Hash, :schema, :wrong_element_type, :schema, [:key], :key, String, "Integer"]'
          )
        end
      end

      describe "because of the target" do
        before { attributes[:handler] = String }

        it "builds the message with every keyword" do
          expect { perform }.to raise_error(
            ApplicationService::Exceptions::Input,
            "[ProcMessageKeywordsService] `handler`: [String, :be_target, nil, :target, " \
            "[Usual::TestKit::Rspec::Matchers::ProcMessageKeywordsService::Handler]]"
          )
        end
      end
    end
  end
end
