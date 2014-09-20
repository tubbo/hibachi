module Hibachi
  class Model
    module Recipe
      extend ActiveSupport::Concern

      included do
        cattr_accessor :recipe_name, :options
      end

      module ClassMethods
        def recipe new_recipe_name, options={}
          self.recipe_name = new_recipe_name
          self.options = options.with_indifferent_access
        end

        # A string of the recipe name, or the entire cookbook by default.
        def recipe_name
          _recipe_name || Hibachi.config.cookbook_name
        end

        # Find all attributes for the current recipe.
        def recipe_attributes
          chef_server.current_node.attributes[recipe_name]
        end

        # An optional namespace that can house all of the attributes for
        # this model.
        def namespace
          options[:namespace] || recipe_name
        end
      end

      # The recipe signature that is to be defined within Chef.
      def recipe
        "recipe[#{recipe_name}]"
      end

      # An optional namespace that can house all of the attributes for
      # this model.
      def namespace
        self.class.namespace
      end

      # A string of the recipe name, or the entire cookbook by default.
      def recipe_name
        self.class.recipe_name
      end
    end
  end
end
