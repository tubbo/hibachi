module Hibachi
  # Methods for querying the contents of a collection of attributes.
  # Typically used for recipes with a collection of attributes.
  module Querying
    include Enumerable

    # Write the given attrs to config and re-run Chef.
    def create from_attributes={}
      model = new from_attributes
      model.save
      model
    end

    # Find everything from the JSON.
    def all
      return fetch if singleton?
      node[recipe_name].map { |from_params| new from_params }
    end

    def each
      all.each { |model| yield model }
    end

    # Find all objects of this type matching the given search
    # criteria. Uses the all() method to scope calls from within the
    # proper JSON for this class, and instantiates objects based on
    # the found information, so you get back an Array of whatever
    # object this model happens to be. If none, this returns an empty
    # Array.
    def where has_attributes={}
      return fetch if singleton?
      all.select { |persisted_attr, persisted_val|
        has_attributes.any? { |search_attr, search_val|
          persisted_attr == search_attr && persisted_val == search_val
        }
      }.map { |from_params|
        new from_params
      }
    end

    # Find a given model by name, or return `nil`. Aliases to `fetch` if
    # this model is a singleton.
    def find by_name=""
      return fetch if singleton?
      where(name: by_name).first
    end

    # Use all the attributes in this recipe to deploy the model if this
    # is a Singleton.
    def fetch
      model = new node[recipe_name]
      model.valid?
      model
    end
  end
end
