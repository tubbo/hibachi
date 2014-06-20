require 'active_model'
require 'hibachi/recipe'
require 'hibachi/store'
require 'hibachi/node'

module Hibachi
  # A Rails model backend for describing machine configuration and
  # exposing such configuration to manipulation by the end user.
  # Hibachi::Model is subclassed like an ActiveRecord::Base, you define
  # attributes on the class that map to attributes in each model's JSON
  # representation.
  class Model
    include ActiveModel::Model
    include Recipe, Store

    # Store all attributes in this Hash.
    attr_accessor :attributes

    # Set attributes to the main collector before assigning them to
    # methods.
    def initialize(from_attrs)
      self.attributes = from_attrs
      super
    end

    # The JSON representation of each Model object is simply its
    # attributes exposed as JSON.
    def to_json
      attributes.to_json
    end

    # Accessor for the global Chef JSON.
    def self.node
      Node.new(file_path: Hibachi.config.chef_json_path)
    end

    # Accessor for the global Chef JSON in an instance.
    def node
      self.class.node
    end

    protected
    def config
      Hibachi.config
    end
  end
end
