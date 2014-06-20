module Hibachi
  module Querying
    # Write the given attrs to config and re-run Chef.
    def create from_attributes={}
      model = fetch_or_initialize from_attributes
      model.save
      model
    end

    # Find everything from the JSON.
    def all
      return fetch if singleton?
      node[recipe_name].map { |from_params| new from_params }
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

    # Find a given model by name, or return `nil`.
    def find by_name=""
      return fetch if singleton?
      where(name: by_name).first
    end

    private
    def fetch_or_initialize from_attributes={}
      if singleton?
        m = fetch
        m.attributes = m.attributes.merge from_attributes
        m
      else
        new from_attributes
      end
    end
  end
end
