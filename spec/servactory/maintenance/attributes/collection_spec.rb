# frozen_string_literal: true

RSpec.describe Servactory::Maintenance::Attributes::Collection do
  let(:attribute_class) { Struct.new(:name, :type) }

  let(:first_name) { attribute_class.new(:first_name, String) }
  let(:middle_name) { attribute_class.new(:middle_name, String) }
  let(:last_name) { attribute_class.new(:last_name, String) }

  let(:collection) { described_class.new << first_name << middle_name << last_name }

  describe "#<<" do
    context "when the name is not declared yet" do
      it "appends the attribute" do
        expect(collection.map(&:itself)).to eq([first_name, middle_name, last_name])
      end
    end

    context "when the name is already declared" do
      let(:redeclared) { attribute_class.new(:middle_name, Symbol) }

      before { collection << redeclared }

      it "replaces the declaration in place", :aggregate_failures do
        expect(collection.map(&:itself)).to eq([first_name, redeclared, last_name])
        expect(collection.names).to eq(%i[first_name middle_name last_name])
      end

      it "finds the redeclared attribute" do
        expect(collection.find_by(name: :middle_name)).to be(redeclared)
      end
    end

    context "when a duplicate redeclares a name" do
      let(:parent) { collection }
      let(:child) { parent.dup }
      let(:redeclared) { attribute_class.new(:middle_name, Symbol) }

      before { child << redeclared }

      it "replaces the declaration only in the duplicate", :aggregate_failures do
        expect(child.map(&:itself)).to eq([first_name, redeclared, last_name])
        expect(parent.map(&:itself)).to eq([first_name, middle_name, last_name])
        expect(parent.find_by(name: :middle_name)).to be(middle_name)
      end
    end
  end

  describe "#merge" do
    let(:redeclared) { attribute_class.new(:first_name, Symbol) }
    let(:suffix) { attribute_class.new(:suffix, String) }

    before { collection.merge([redeclared, suffix]) }

    it "replaces redeclared names in place and appends new ones" do
      expect(collection.map(&:itself)).to eq([redeclared, middle_name, last_name, suffix])
    end
  end

  describe Servactory::Inputs::Collection do
    let(:attribute_class) { Struct.new(:name, :internal_name, :type) }

    let(:collection) { described_class.new << attribute << other_attribute }

    let(:attribute) { attribute_class.new(:user_id, :id, Integer) }
    let(:other_attribute) { attribute_class.new(:email, :email, String) }

    context "when an input is redeclared by its name without `as:`" do
      let(:redeclared) { attribute_class.new(:user_id, :user_id, String) }

      before { collection << redeclared }

      it "replaces the declaration in place", :aggregate_failures do
        expect(collection.map(&:itself)).to eq([redeclared, other_attribute])
        expect(collection.find_by(name: :user_id)).to be(redeclared)
        expect(collection.find_by(name: :id)).to be_nil
      end
    end

    context "when another input reuses an internal name" do
      let(:other_input) { attribute_class.new(:id, :id, String) }

      before { collection << other_input }

      it "keeps both declarations" do
        expect(collection.map(&:itself)).to eq([attribute, other_attribute, other_input])
      end
    end
  end
end
