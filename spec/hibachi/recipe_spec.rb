require 'spec_helper'
require 'hibachi/recipe'

module Hibachi
  describe Recipe do
    context "with a singleton setting" do
      subject { SingletonSetting }

      it "sets the recipe in the class definition" do
        expect(subject.recipe_name).to eq(:singleton_settings)
      end

      it "sets the type of recipe in the class definition" do
        expect(subject.recipe_type).to eq('singleton')
      end

      it "is a singleton" do
        expect(subject).to be_singleton
      end

      context "with an instantiated setting" do
        let(:setting) { subject.new name: 'test' }

        it "is a singleton" do
          expect(setting).to be_singleton
        end
      end
    end

    context "with a collection setting" do
      subject { MockSetting }

      it "sets the recipe in the class definition" do
        expect(subject.recipe_name).to eq(:mock_settings)
      end

      it "sets the type of recipe in the class definition" do
        expect(subject.recipe_type).to eq('collection')
      end

      it "is a collection" do
        expect(subject).to be_collection
      end

      context "with an instantiated setting" do
        let(:setting) { subject.new name: 'test' }

        it "is a collection" do
          expect(setting).to be_collection
        end
      end
    end

  end
end
