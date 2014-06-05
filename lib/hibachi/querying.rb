module Hibachi
  # Methods for running queries on collections of data from the JSON.
  module Querying
    def all
      chef_json[recipe]
    end

    def where has_attributes={}
      []
    end
  end
end
