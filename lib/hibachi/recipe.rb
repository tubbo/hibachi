module Hibachi
  # Methods for manipulating and reading the recipe of the model class.
  module Recipe
    extend ActiveSupport::Concern

    module ClassMethods
      cattr_accessor :recipe_name

      # Set the recipe on this model. You can feel free to omit the
      # '::default', but if you have a '::' in there the code will not
      # touch this name.
      def recipe name
        self.recipe_name = name
      end
    end

    # Return the recipe name as set in the class definition.
    def recipe
      self.class.recipe_name
    end

    protected
    def cookbook
      Hibachi.config.cookbook
    end
  end
end
