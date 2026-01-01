# frozen_string_literal: true

RSpec.describe Servactory::Stroma::DSL do
  describe ".included" do
    let(:base_class) do
      Class.new do
        include Servactory::Stroma::DSL
      end
    end

    it "extends the class with ClassMethods", :aggregate_failures do
      expect(base_class).to respond_to(:stroma)
      expect(base_class).to respond_to(:inherited)
    end

    it "includes all registered DSL modules" do
      Servactory::Stroma::Registry.entries.each do |entry|
        expect(base_class.ancestors).to(
          include(entry.extension),
          "Expected ancestors to include #{entry.extension} (key: #{entry.key})"
        )
      end
    end

    it "creates a stroma configuration" do
      expect(base_class.stroma).to be_a(Servactory::Stroma::Configuration)
    end
  end

  describe "inheritance" do
    let(:extension_module) do
      Module.new do
        def self.included(base)
          base.define_singleton_method(:extension_method) { :extension_result }
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

    it "child has extension method", :aggregate_failures do
      expect(child_class).to respond_to(:extension_method)
      expect(child_class.extension_method).to eq(:extension_result)
    end

    it "copies stroma configuration to child", :aggregate_failures do
      expect(child_class.stroma).not_to eq(base_class.stroma)
      expect(child_class.stroma).to be_a(Servactory::Stroma::Configuration)
    end

    it "hooks are inherited" do
      grandchild = Class.new(child_class)
      expect(grandchild.ancestors).to include(extension_module)
    end
  end

  describe "#extensions" do
    let(:first_module) { Module.new }
    let(:second_module) { Module.new }

    let(:base_class) do
      first_ext = first_module
      second_ext = second_module
      Class.new do
        include Servactory::Stroma::DSL

        extensions do
          before :actions, first_ext
          after :outputs, second_ext
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
