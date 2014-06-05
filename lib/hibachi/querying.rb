module Hibachi
  module Querying
    extend ActiveSupport::Concern

    module ClassMethods
      # Find everything from the JSON.
      def all
        node[recipe]
      end

      # Find all objects of this type matching the given search
      # criteria. Uses the all() method to scope calls from within the
      # proper JSON for this class, and instantiates objects based on
      # the found information, so you get back an Array of whatever
      # object this model happens to be.
      def where has_attributes={}
        all.select { |persisted_attr, persisted_val|
          has_attributes.any? { |search_attr, search_val|
            persisted_attr == search_attr && persisted_val == search_val
          }
        }.map { |from_params|
          new from_params
        }
      end
    end
  end
end
