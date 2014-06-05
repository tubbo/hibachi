module Hibachi
  # Methods for running queries on collections of data from the JSON.
  module Querying
    extend ActiveSupport::Concern

    module ClassMethods
      # Find everything from the JSON.
      def all
        chef_json[recipe]
      end

      # Find everything matching the given attrs from the JSON.
      def where has_attributes={}
        []
      end
    end

    # Tests if this particular ID is in the JSON.
    def persisted?
      chef_json[recipe].include? self
    end
  end
end
