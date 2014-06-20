require 'spec_helper'
require 'hibachi/recipe'

module Hibachi
  describe Recipe do
    class MockForRecipe < Hibachi::Model
      recipe :name_of_recipe, :type => :singleton

      attr_accessor :name
    end

    it "sets the recipe in the class definition" do
      expect(MockForRecipe.recipe_name).to eq(:name_of_recipe)
    end

    it "sets the type of recipe in the class definition" do
      expect(MockForRecipe.recipe_type).to eq('singleton')
    end

    it "is a singleton" do
      expect(MockForRecipe).to be_singleton
    end

    context "with an instantiated singleton" do
      subject { MockForRecipe.new name: 'test' }

      it "is a singleton" do
        expect(subject).to be_singleton
      end
    end
  end
end
