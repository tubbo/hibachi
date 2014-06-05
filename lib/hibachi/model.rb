require 'active_model'
require 'hibachi/chef_json'
require 'hibachi/persistence'
require 'hibachi/configuration'
require 'hibachi/querying'

module Hibachi
  class Model
    include ActiveModel::Model
    include Persistence
    include Configuration
    extend  Querying

    attr_accessor :attributes

    # Accessor for the global Chef JSON.
    def self.chef_json
      ChefJSON.fetch
    end

    private
    def chef_json
      self.class.chef_json
    end
  end
end
