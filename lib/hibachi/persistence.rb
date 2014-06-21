module Hibachi
  # Backend data store methods for the Hibachi::Model
  module Store
    extend ActiveSupport::Concern

    # Merge attrs and write to JSON.
    def save
      persist and chef
    end

    # Update an existing model's attributes.
    def update_attributes(attrs={})
      merge(attrs) and save
    end

    # Remove the given id from the JSON and re-run Chef.
    def destroy
      clear and chef
    end

    # Test if this model appears in the Node JSON.
    def persisted?
      if collection?
        node[recipe][id].present?
      else
        node[recipe].present?
      end
    end

    # Returns `true` if it's not currently being persisted.
    def new_record?
      (not persisted?)
    end

    private
    def merge(new_attrs={})
      @attributes = @attributes.merge new_attrs
      attributes.each do |key, value|
        setter = "#{key}="
        send setter, value if respond_to? setter
      end
    end

    def persist
      @persisted ||= if new_record?
        create
      else
        update
      end
    end

    def create
      node.merge! recipe => new_recipe_attributes
    end

    def update
      node.merge! recipe_name => new_recipe_attributes
    end

    def new_recipe_attributes
      if singleton?
        node[recipe].merge attributes
      else
        node[recipe].merge id => attributes
      end
    end

    def clear
      if singleton?
        node.delete!
      else
        node.delete id
      end
    end
  end
end
