module Hibachi
  class Model
    module Recipe
      extend ActiveSupport::Concern

      included do
        cattr_accessor :_recipe_name
      end

      module ClassMethods
        def recipe_name new_recipe_name
          self._recipe_name = new_recipe_name
        end
      end

      def recipe
      end

      private
      def recipe_name
        self.class._recipe_name || default_recipe_name
      end

      private
      def default_recipe_name
        "recipe[#{Hibachi.cookbook_name}::default]"
      end
    end
  end
end
