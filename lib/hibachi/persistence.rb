module Hibachi
  # Backend data store methods for the Hibachi::Model
  module Store
    extend ActiveSupport::Concern

    # Merge attrs and write to JSON.
    def save
      persist and chef
    end

    def update_attributes(attrs={})
      merge(attrs) and update and save
    end

    # Remove the given id from the JSON and re-run Chef.
    def destroy
      clear and chef
    end

    def persisted?
      return node[recipe_name][id].present? unless singleton?
      node[recipe_name].present?
    end

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
      node.merge! recipe_name => new_recipe_attributes
    end

    def update
      node.merge! recipe_name => new_recipe_attributes
    end

    def new_recipe_attributes
      if singleton?
        node[recipe_name].merge attributes
      else
        node[recipe_name].merge id => attributes
      end
    end

    def clear
      if singleton?
        node.delete!
      else
        node.merge! recipe_name => nil
      end
    end
  end
end
