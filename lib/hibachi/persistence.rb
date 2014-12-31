module Hibachi
  # Backend data store methods for the Hibachi::Model
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      # Accessor for the global Chef JSON.
      def node
        @node ||= Node.find Hibachi.config.node_name
      end
    end

    # Merge attrs and write to JSON.
    def save
      run_callbacks :save do
        if valid?
          node.update_attributes recipe => new_recipe_attributes
        else
          false
        end
      end
    end

    # Update an existing model's attributes.
    def update_attributes(attrs={})
      merge(attrs) and save
    end

    # Remove the given id from the JSON and re-run Chef.
    def destroy
      clear and converge
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

    # Accessor for the global Chef JSON in an instance.
    def node
      self.class.node
    end
  end
end
