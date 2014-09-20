module Hibachi
  class Model
    module Collection
      extend ActiveSupport::Concern

      module ClassMethods
        # Test if this model is a collection.
        def collection?
          !!options[:collection]
        end

        def create(from_attributes={})
          throw_error unless collection?
          model = new from_attributes
          model.save
          model
        end

        def find(by_key)
          throw_error unless collection?
          new recipe_attributes[by_key] if recipe_attributes[by_key].present?
        end

        private
        def throw_error
          raise Hibachi::Error, "#{name} is not a collection model"
        end
      end

      # Find whether class was configured to be a collection.
      def collection?
        self.class.collection?
      end
    end
  end
end
