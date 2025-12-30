# frozen_string_literal: true

RSpec.describe Servactory::Stroma::DSL do
  describe ".included" do
    let(:base_class) do
      Class.new do
        include Servactory::Stroma::DSL
      end
    end

    it "extends the class with ClassMethods" do
      expect(base_class).to respond_to(:stroma)
      expect(base_class).to respond_to(:inherited)
    end

    it "includes all registered DSL modules" do
      expect(base_class.ancestors).to include(Servactory::Configuration::DSL)
      expect(base_class.ancestors).to include(Servactory::Inputs::DSL)
      expect(base_class.ancestors).to include(Servactory::Outputs::DSL)
      expect(base_class.ancestors).to include(Servactory::Actions::DSL)
    end

    it "creates a stroma configuration" do
      expect(base_class.stroma).to be_a(Servactory::Stroma::Configuration)
    end
  end

  describe "inheritance" do
    let(:extension_module) do
      Module.new do
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def extension_method
            :extension_result
          end
        end
      end
    end

    let(:base_class) do
      ext = extension_module
      Class.new do
        include Servactory::Stroma::DSL

        extensions do
          before :actions, ext
        end
      end
    end

    let(:child_class) { Class.new(base_class) }

    it "applies hooks to child class" do
      expect(child_class.ancestors).to include(extension_module)
    end

    it "child has extension method" do
      expect(child_class).to respond_to(:extension_method)
      expect(child_class.extension_method).to eq(:extension_result)
    end

    it "copies stroma configuration to child" do
      expect(child_class.stroma).not_to eq(base_class.stroma)
      expect(child_class.stroma).to be_a(Servactory::Stroma::Configuration)
    end

    it "hooks are inherited" do
      grandchild = Class.new(child_class)
      expect(grandchild.ancestors).to include(extension_module)
    end
  end

  describe "#extensions" do
    let(:test_module1) { Module.new }
    let(:test_module2) { Module.new }

    let(:base_class) do
      mod1 = test_module1
      mod2 = test_module2
      Class.new do
        include Servactory::Stroma::DSL

        extensions do
          before :actions, mod1
          after :outputs, mod2
        end
      end
    end

    it "registers before hooks" do
      expect(base_class.stroma.hooks.before(:actions).size).to eq(1)
    end

    it "registers after hooks" do
      expect(base_class.stroma.hooks.after(:outputs).size).to eq(1)
    end
  end
end
