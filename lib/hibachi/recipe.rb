module Hibachi
  # Methods for manipulating and reading the recipe of the model class,
  # as well as defining whether this recipe is a singleton or
  # collection.
  module Recipe
    extend ActiveSupport::Concern

    module ClassMethods
      cattr_accessor :recipe_name, :recipe_type

      # Set the recipe on this model. You can feel free to omit the
      # '::default', but if you have a '::' in there the code will not
      # touch this name. By default, this creates a 'collection' recipe.
      def recipe name, options={}
        self.recipe_name = name
        from_opts = "#{options[:type]}" || 'collection'
        self.recipe_type = ActiveSupport::StringInquirer.new from_opts
      end

      # An alias for `recipe` to give parity to `singleton_recipe`.
      alias collection_recipe recipe

      # Shorthand for creating a 'singleton' recipe, you can also simply
      # pass :type => :singleton in the `recipe` call.
      def singleton_recipe name
        recipe name, :type => :singleton
      end

      delegate :collection?, :to => :recipe_type
      delegate :singleton?, :to => :recipe_type
    end

    # Return the recipe name as set in the class definition.
    def recipe
      self.class.recipe_name
    end

    # Return the recipe type as set in the class definition. It's a
    # StringInquirer, so it defines methods that allow us to test
    # whether this is a `collection?` or a `singleton?`.
    def type
      self.class.recipe_type
    end

    delegate :collection?, :to => :type
    delegate :singleton?, :to => :type
  end
end
