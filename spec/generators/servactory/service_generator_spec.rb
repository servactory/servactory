# frozen_string_literal: true

require "generators/servactory/service/service_generator"

RSpec.describe "Servactory::Generators::ServiceGenerator" do
  include GeneratorHelpers

  tests Servactory::Generators::ServiceGenerator

  describe "#create_service" do
    describe "file creation" do
      context "with simple name" do
        before { run_generator %w[ProcessOrder] }

        it "creates service file", :aggregate_failures do
          assert_file "app/services/process_order.rb"

          content = file_content("app/services/process_order.rb")
          expect(content).to include("class ProcessOrder < ApplicationService::Base")
          expect(content).to include("make :assign_data")
          expect(content).to include("output :data, type: String")
        end
      end

      context "with namespaced name" do
        before { run_generator %w[Users::Create] }

        it "creates service file in correct directory", :aggregate_failures do
          assert_file "app/services/users/create.rb"

          content = file_content("app/services/users/create.rb")
          expect(content).to include("class Users::Create < ApplicationService::Base")
        end
      end
    end

    describe "input type handling" do
      context "with lowercase types (Rails format)" do
        before { run_generator %w[Users::Create email:string count:integer] }

        it "normalizes lowercase types to Ruby classes", :aggregate_failures do
          content = file_content("app/services/users/create.rb")
          expect(content).to include("input :email, type: String")
          expect(content).to include("input :count, type: Integer")
        end
      end

      context "with capitalized types (Ruby class names)" do
        before { run_generator %w[Users::Create email:String count:Integer] }

        it "preserves capitalized Ruby class names", :aggregate_failures do
          content = file_content("app/services/users/create.rb")
          expect(content).to include("input :email, type: String")
          expect(content).to include("input :count, type: Integer")
        end
      end

      context "with custom model types" do
        before { run_generator %w[ProcessOrder user:User event:Event] }

        it "preserves custom type names", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :user, type: User")
          expect(content).to include("input :event, type: Event")
        end
      end

      context "with nested namespace types" do
        before { run_generator %w[ProcessOrder role:Admin::Users::Role status:Billing::PaymentStatus] }

        it "preserves nested namespace types", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :role, type: Admin::Users::Role")
          expect(content).to include("input :status, type: Billing::PaymentStatus")
        end
      end

      context "with boolean type variations" do
        before { run_generator %w[ToggleFeature enabled:boolean flag:bool] }

        it "normalizes boolean types to TrueClass/FalseClass array", :aggregate_failures do
          content = file_content("app/services/toggle_feature.rb")
          expect(content).to include("input :enabled, type: [TrueClass, FalseClass]")
          expect(content).to include("input :flag, type: [TrueClass, FalseClass]")
        end
      end

      context "with untyped inputs" do
        before { run_generator %w[SendEmail recipient subject] }

        it "defaults to String type", :aggregate_failures do
          content = file_content("app/services/send_email.rb")
          expect(content).to include("input :recipient, type: String")
          expect(content).to include("input :subject, type: String")
        end
      end

      context "with collection types" do
        before { run_generator %w[ProcessData items:array options:hash] }

        it "normalizes collection types to Ruby classes", :aggregate_failures do
          content = file_content("app/services/process_data.rb")
          expect(content).to include("input :items, type: Array")
          expect(content).to include("input :options, type: Hash")
        end
      end

      context "with symbol type" do
        before { run_generator %w[ProcessOrder status:symbol] }

        it "normalizes symbol to Symbol class", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :status, type: Symbol")
        end
      end

      context "with temporal types" do
        before { run_generator %w[ScheduleEvent event_date:date start_time:time scheduled_at:datetime] }

        it "normalizes temporal types to Ruby classes", :aggregate_failures do
          content = file_content("app/services/schedule_event.rb")
          expect(content).to include("input :event_date, type: Date")
          expect(content).to include("input :start_time, type: Time")
          expect(content).to include("input :scheduled_at, type: DateTime")
        end
      end

      context "with nil type" do
        before { run_generator %w[ProcessOrder value:nil] }

        it "normalizes nil to NilClass", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :value, type: NilClass")
        end
      end

      context "with decimal type" do
        before { run_generator %w[ProcessOrder amount:decimal] }

        it "normalizes decimal to BigDecimal", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :amount, type: BigDecimal")
        end
      end
    end

    describe "generator options" do
      context "with --base-class option" do
        before { run_generator %w[ProcessOrder --base-class=CustomService::Base] }

        it "uses custom base class", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("class ProcessOrder < CustomService::Base")
        end
      end

      context "with --path option" do
        before { run_generator %w[ProcessOrder --path=lib/my_gem/services] }

        it "creates service file in custom path", :aggregate_failures do
          assert_file "lib/my_gem/services/process_order.rb"
          assert_no_file "app/services/process_order.rb"

          content = file_content("lib/my_gem/services/process_order.rb")
          expect(content).to include("class ProcessOrder < ApplicationService::Base")
        end
      end

      context "with --path option and namespaced name" do
        before { run_generator %w[Users::Create --path=lib/my_gem/services] }

        it "creates service file in custom path with namespace", :aggregate_failures do
          assert_file "lib/my_gem/services/users/create.rb"
          assert_no_file "app/services/users/create.rb"
        end
      end

      context "with --skip-output option" do
        before { run_generator %w[ProcessOrder --skip-output] }

        it "does not include output declaration", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).not_to include("output :data")
          expect(content).not_to include('outputs.data = "done"')
        end
      end
    end

    describe "input name validation" do
      context "with invalid input names" do
        it "rejects empty input names" do
          expect { run_generator %w[ProcessOrder :string] }.to raise_error(ArgumentError, /Invalid input name/)
        end

        it "rejects names starting with numbers" do
          expect { run_generator %w[ProcessOrder 123name:string] }.to raise_error(ArgumentError, /Invalid input name/)
        end

        it "rejects names with special characters" do
          expect { run_generator %w[ProcessOrder my-name:string] }.to raise_error(ArgumentError, /Invalid input name/)
        end

        it "rejects names with spaces" do
          expect { run_generator ["ProcessOrder", "my name:string"] }
            .to raise_error(ArgumentError, /Invalid input name/)
        end

        it "rejects names starting with uppercase" do
          expect { run_generator %w[ProcessOrder MyName:string] }.to raise_error(ArgumentError, /Invalid input name/)
        end
      end

      context "with valid input names" do
        it "accepts names starting with underscore" do
          expect { run_generator %w[ProcessOrder _private:string] }.not_to raise_error
          assert_file "app/services/process_order.rb"
        end

        it "accepts snake_case names" do
          expect { run_generator %w[ProcessOrder user_email:string] }.not_to raise_error
        end

        it "accepts names with numbers (not at start)" do
          expect { run_generator %w[ProcessOrder field2:string] }.not_to raise_error
        end
      end

      context "with whitespace in input names" do
        before { run_generator ["ProcessOrder", " email :string"] }

        it "strips whitespace from input names", :aggregate_failures do
          content = file_content("app/services/process_order.rb")
          expect(content).to include("input :email, type: String")
          expect(content).not_to include("input : email")
        end
      end
    end

    describe "generated code validity" do
      context "with simple service" do
        before { run_generator %w[ProcessOrder] }

        it_behaves_like "generates valid Ruby syntax", "app/services/process_order.rb"
      end

      context "with complex inputs" do
        before { run_generator %w[ProcessOrder email:string count:integer flag:boolean] }

        it_behaves_like "generates valid Ruby syntax", "app/services/process_order.rb"
      end

      context "with namespaced service" do
        before { run_generator %w[Admin::Users::ProcessOrder] }

        it_behaves_like "generates valid Ruby syntax", "app/services/admin/users/process_order.rb"
      end
    end
  end
end
