require 'active_model'
require 'hibachi/chef_json'
require 'hibachi/persistence'
require 'hibachi/configuration'
require 'hibachi/querying'
require 'hibachi/recipe'

module Hibachi
  # A Rails model backend for describing machine configuration and
  # exposing such configuration to manipulation by the end user.
  # Hibachi::Model is subclassed like an ActiveRecord::Base, you define
  # attributes on the class that map to attributes in each model's JSON
  # representation.
  class Model
    include ActiveModel::Model

    include Persistence
    include Configuration
    include Recipe
    include Querying

    attr_accessor :attributes

    # The JSON representation of each Model object is simply its
    # attributes exposed as JSON.
    def to_json
      attributes.to_json
    end

    # Accessor for the global Chef JSON.
    def self.node
      Node.new Hibachi.config.chef_json_path
    end

    # Accessor for the Chef JSON for this recipe.
    def node
      self.class.node[self.class.recipe_name]
    end
  end
end
