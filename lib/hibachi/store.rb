module Hibachi
  # Backend data store methods for the Hibachi::Model
  module Store
    extend ActiveSupport::Concern

    module ClassMethods
      # Write the given attrs to config and re-run Chef.
      def create from_attributes={}
        model = new from_attributes
        model.save
        model
      end

      # Find everything from the JSON.
      def all
        node[recipe].map { |from_params| new from_params }
      end

      # Find all objects of this type matching the given search
      # criteria. Uses the all() method to scope calls from within the
      # proper JSON for this class, and instantiates objects based on
      # the found information, so you get back an Array of whatever
      # object this model happens to be. If none, this returns an empty
      # Array.
      def where has_attributes={}
        all.select { |persisted_attr, persisted_val|
          has_attributes.any? { |search_attr, search_val|
            persisted_attr == search_attr && persisted_val == search_val
          }
        }.map { |from_params|
          new from_params
        }
      end

      # Find a given model by name, or return `nil`.
      def find by_name
        where(name: by_name).first
      end
    end

    # Merge attrs and write to JSON.
    def save
      persist and chef
    end

    # Remove the given id from the JSON and re-run Chef.
    def destroy
      clear and chef
    end

    def persisted?
      @persisted
    end

    def new_record?
      (not persisted?)
    end

    private
    def persist
      @persisted ||= node.merge recipe => attributes
    end

    def clear
      node.delete id
    end

    def chef
      Hibachi.run_chef recipe, background: run_in_background?
    end

    def run_in_background?
      Hibachi.config.run_in_background
    end
  end
end
