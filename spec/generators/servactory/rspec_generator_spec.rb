# frozen_string_literal: true

require "generators/servactory/rspec/rspec_generator"

RSpec.describe "Servactory::Generators::RspecGenerator" do
  include GeneratorHelpers

  tests Servactory::Generators::RspecGenerator

  describe "#create_spec_file" do
    describe "file creation" do
      context "with simple name" do
        before { run_generator %w[ProcessOrder] }

        it "creates spec file in spec/services/ NOT app/services/", :aggregate_failures do
          assert_file "spec/services/process_order_spec.rb"
          assert_no_file "app/services/process_order_spec.rb"
        end

        it "creates spec with correct structure", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include("RSpec.describe ProcessOrder, type: :service do")
          expect(content).to include('pending "add some examples to (or delete) #{__FILE__}"')
          expect(content).to include('describe ".call!" do')
          expect(content).to include("subject(:perform) { described_class.call!(**attributes) }")
        end

        it "creates spec with placeholder for attributes when no inputs provided", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include("let(:attributes) do")
          expect(content).to include("# TODO: Add input attributes")
        end
      end

      context "with namespaced name" do
        before { run_generator %w[Users::Create] }

        it "creates spec file in correct directory", :aggregate_failures do
          assert_file "spec/services/users/create_spec.rb"

          content = file_content("spec/services/users/create_spec.rb")
          expect(content).to include("RSpec.describe Users::Create, type: :service do")
        end
      end
    end

    describe "input handling" do
      context "with input arguments" do
        before { run_generator %w[Users::Create email:string name:string] }

        it "creates spec with input attributes", :aggregate_failures do
          content = file_content("spec/services/users/create_spec.rb")
          expect(content).to include("let(:attributes) do")
          expect(content).to include("email: email,")
          expect(content).to include("name: name")
          expect(content).to include('let(:email) { "Some value" }')
          expect(content).to include('let(:name) { "Some value" }')
        end

        it "creates spec with validation examples", :aggregate_failures do
          content = file_content("spec/services/users/create_spec.rb")
          expect(content).to include('describe "validations"')
          expect(content).to include('describe "inputs"')
          expect(content).to include("have_input(:email)")
          expect(content).to include("have_input(:name)")
          expect(content).to include(".type(String)")
          expect(content).to include(".required")
        end
      end

      context "with typed input arguments" do
        before { run_generator %w[ProcessOrder user_id:integer amount:float confirmed:boolean] }

        it "generates correct example values for each type", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include("let(:user_id) { 1 }")
          expect(content).to include("let(:amount) { 1.0 }")
          expect(content).to include("let(:confirmed) { true }")
        end

        it "generates correct type assertions", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include(".type(Integer)")
          expect(content).to include(".type(Float)")
          expect(content).to include(".type([TrueClass, FalseClass])")
        end
      end
    end

    describe "generator options" do
      context "with --call-method=call option" do
        before { run_generator %w[ProcessOrder --call-method=call] }

        it "uses .call instead of .call!", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include('describe ".call" do')
          expect(content).to include("subject(:perform) { described_class.call(**attributes) }")
          expect(content).not_to include(".call!")
        end
      end

      context "with --path option for app/ path" do
        before { run_generator %w[ProcessOrder --path=app/domain/services] }

        it "converts app/ to spec/ for spec path", :aggregate_failures do
          assert_file "spec/domain/services/process_order_spec.rb"
          assert_no_file "spec/services/process_order_spec.rb"
          assert_no_file "app/domain/services/process_order_spec.rb"
        end
      end

      context "with --path option for lib/ path" do
        before { run_generator %w[ProcessOrder --path=lib/my_gem/services] }

        it "converts lib/ to spec/ for spec path", :aggregate_failures do
          assert_file "spec/my_gem/services/process_order_spec.rb"
          assert_no_file "spec/lib/my_gem/services/process_order_spec.rb"
          assert_no_file "lib/my_gem/services/process_order_spec.rb"
        end
      end

      context "with --path option and namespaced name" do
        before { run_generator %w[Users::Create --path=lib/my_gem/services] }

        it "creates spec file in custom path with namespace", :aggregate_failures do
          assert_file "spec/my_gem/services/users/create_spec.rb"
          assert_no_file "spec/services/users/create_spec.rb"
        end
      end

      context "with --skip-pending option" do
        before { run_generator %w[ProcessOrder --skip-pending] }

        it "creates spec without pending placeholder", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).not_to include("pending")
        end
      end
    end

    describe "path conversion" do
      context "with Rails engine app/ path" do
        before { run_generator %w[ProcessOrder --path=engines/core/app/services] }

        it "converts engines/*/app/ to engines/*/spec/", :aggregate_failures do
          assert_file "engines/core/spec/services/process_order_spec.rb"
          assert_no_file "spec/engines/core/app/services/process_order_spec.rb"
          assert_no_file "engines/core/app/services/process_order_spec.rb"
        end
      end

      context "with Rails engine lib/ path" do
        before { run_generator %w[ProcessOrder --path=engines/admin/lib/services] }

        it "converts engines/*/lib/ to engines/*/spec/", :aggregate_failures do
          assert_file "engines/admin/spec/services/process_order_spec.rb"
          assert_no_file "spec/engines/admin/lib/services/process_order_spec.rb"
        end
      end

      context "with namespaced service in engine" do
        before { run_generator %w[Users::Create --path=engines/core/app/services] }

        it "creates spec file in engine spec path with namespace", :aggregate_failures do
          assert_file "engines/core/spec/services/users/create_spec.rb"
        end
      end
    end

    describe "type example values" do
      context "with collection types" do
        before { run_generator %w[ProcessData items:array options:hash] }

        it "generates correct example values for collections", :aggregate_failures do
          content = file_content("spec/services/process_data_spec.rb")
          expect(content).to include("let(:items) { [] }")
          expect(content).to include("let(:options) { {} }")
          expect(content).to include(".type(Array)")
          expect(content).to include(".type(Hash)")
        end
      end

      context "with symbol type" do
        before { run_generator %w[ProcessOrder status:symbol] }

        it "generates symbol example value", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include("let(:status) { :example }")
          expect(content).to include(".type(Symbol)")
        end
      end

      context "with temporal types" do
        before { run_generator %w[ScheduleEvent event_date:date start_time:time scheduled_at:datetime] }

        it "generates correct example values for temporal types", :aggregate_failures do
          content = file_content("spec/services/schedule_event_spec.rb")
          expect(content).to include("let(:event_date) { Date.current }")
          expect(content).to include("let(:start_time) { Time.current }")
          expect(content).to include("let(:scheduled_at) { DateTime.current }")
          expect(content).to include(".type(Date)")
          expect(content).to include(".type(Time)")
          expect(content).to include(".type(DateTime)")
        end
      end

      context "with nil type" do
        before { run_generator %w[ProcessOrder value:nil] }

        it "generates nil example value", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include("let(:value) { nil }")
          expect(content).to include(".type(NilClass)")
        end
      end

      context "with decimal type" do
        before { run_generator %w[ProcessOrder amount:decimal] }

        it "generates BigDecimal example value", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include('let(:amount) { BigDecimal("1.0") }')
          expect(content).to include(".type(BigDecimal)")
        end
      end

      context "with string type (default fallback)" do
        before { run_generator %w[SendEmail recipient:string] }

        it "generates string example value", :aggregate_failures do
          content = file_content("spec/services/send_email_spec.rb")
          expect(content).to include('let(:recipient) { "Some value" }')
          expect(content).to include(".type(String)")
        end
      end

      context "with custom model type" do
        before { run_generator %w[ProcessOrder user:User] }

        it "generates default string example for unknown types", :aggregate_failures do
          content = file_content("spec/services/process_order_spec.rb")
          expect(content).to include('let(:user) { "Some value" }')
          expect(content).to include(".type(User)")
        end
      end
    end

    describe "generated code validity" do
      context "with simple spec" do
        before { run_generator %w[ProcessOrder] }

        it_behaves_like "generates valid Ruby syntax", "spec/services/process_order_spec.rb"
      end

      context "with complex inputs" do
        before { run_generator %w[ProcessOrder email:string count:integer flag:boolean] }

        it_behaves_like "generates valid Ruby syntax", "spec/services/process_order_spec.rb"
      end

      context "with namespaced service" do
        before { run_generator %w[Admin::Users::ProcessOrder] }

        it_behaves_like "generates valid Ruby syntax", "spec/services/admin/users/process_order_spec.rb"
      end
    end
  end
end
