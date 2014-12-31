require 'active_model'

require 'hibachi/recipe'
require 'hibachi/persistence'
require 'hibachi/querying'

module Hibachi
  # A Rails model backend for describing machine configuration and
  # exposing such configuration to manipulation by the end user.
  # Hibachi::Model is subclassed like an ActiveRecord::Base, you define
  # attributes on the class that map to attributes in each model's JSON
  # representation.
  class Model
    include ActiveModel::Model
    include Recipe
    include Persistence
    extend Querying

    # Store all attributes in this Hash.
    attr_reader :attributes

    # Set attributes to the main collector before assigning them to
    # methods.
    def initialize(from_attrs={})
      @attributes = from_attrs
      super
    end

    # The JSON representation of each Model object is simply its
    # attributes exposed as JSON.
    def to_json(*arguments)
      @json ||= attributes.to_json
    end

    protected
    def config
      Hibachi.config
    end
  end
end
