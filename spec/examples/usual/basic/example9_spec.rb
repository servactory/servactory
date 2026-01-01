# frozen_string_literal: true

RSpec.describe Usual::Basic::Example9, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[
                      full_name_1 full_name_2 full_name_3 full_name_4
                      full_name_5 full_name_6 full_name_7 full_name_8
                      full_name_9 full_name_10
                    ]

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
            have_input(:middle_name)
              .valid_with(attributes)
              .type(String)
              .optional
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
            have_output(:full_name_1)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_2)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_3)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_4)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_5)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_6)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_7)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_8)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_9)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_10)
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
            .with_outputs(
              full_name_1: "John Fitzgerald Kennedy",
              full_name_2: "John Fitzgerald Kennedy",
              full_name_3: "John Fitzgerald Kennedy",
              full_name_4: "John Fitzgerald Kennedy",
              full_name_5: "John Fitzgerald Kennedy",
              full_name_6: "John Fitzgerald Kennedy",
              full_name_7: "John Fitzgerald Kennedy",
              full_name_8: "John Fitzgerald Kennedy",
              full_name_9: "John Fitzgerald Kennedy",
              full_name_10: "John Fitzgerald Kennedy"
            )
        )
      end

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            be_success_service
              .with_outputs(
                full_name_1: "John Kennedy",
                full_name_2: "John Kennedy",
                full_name_3: "John Kennedy",
                full_name_4: "John Kennedy",
                full_name_5: "John Kennedy",
                full_name_6: "John Kennedy",
                full_name_7: "John Kennedy",
                full_name_8: "John Kennedy",
                full_name_9: "John Kennedy",
                full_name_10: "John Kennedy"
              )
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        first_name:,
        middle_name:,
        last_name:
      }
    end

    let(:first_name) { "John" }
    let(:middle_name) { "Fitzgerald" }
    let(:last_name) { "Kennedy" }

    it_behaves_like "check class info",
                    inputs: %i[first_name middle_name last_name],
                    internals: %i[],
                    outputs: %i[
                      full_name_1 full_name_2 full_name_3 full_name_4
                      full_name_5 full_name_6 full_name_7 full_name_8
                      full_name_9 full_name_10
                    ]

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
            have_input(:middle_name)
              .valid_with(attributes)
              .type(String)
              .optional
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
            have_output(:full_name_1)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_2)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_3)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_4)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_5)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_6)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_7)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_8)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_9)
              .instance_of(String)
          )
        end

        it do
          expect(perform).to(
            have_output(:full_name_10)
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
            .with_outputs(
              full_name_1: "John Fitzgerald Kennedy",
              full_name_2: "John Fitzgerald Kennedy",
              full_name_3: "John Fitzgerald Kennedy",
              full_name_4: "John Fitzgerald Kennedy",
              full_name_5: "John Fitzgerald Kennedy",
              full_name_6: "John Fitzgerald Kennedy",
              full_name_7: "John Fitzgerald Kennedy",
              full_name_8: "John Fitzgerald Kennedy",
              full_name_9: "John Fitzgerald Kennedy",
              full_name_10: "John Fitzgerald Kennedy"
            )
        )
      end

      describe "even if `middle_name` is not specified" do
        let(:middle_name) { nil }

        it do
          expect(perform).to(
            be_success_service
              .with_outputs(
                full_name_1: "John Kennedy",
                full_name_2: "John Kennedy",
                full_name_3: "John Kennedy",
                full_name_4: "John Kennedy",
                full_name_5: "John Kennedy",
                full_name_6: "John Kennedy",
                full_name_7: "John Kennedy",
                full_name_8: "John Kennedy",
                full_name_9: "John Kennedy",
                full_name_10: "John Kennedy"
              )
          )
        end
      end
    end
  end
end
