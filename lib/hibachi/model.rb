require 'active_model'

require 'hibachi/model/recipe'
require 'hibachi/model/collection'
require 'hibachi/chef_runner'

module Hibachi
  # Model class by which all Rails models that are saving to Chef
  # configuration derive. The Hibachi::Model forms the backend, much
  # like ActiveRecord::Base, for your data model class. You can generate
  # it from the command-line like so:
  #
  #   rails generate hibachi:model NAME [ATTRIBUTES]
  #
  # In your class definition, you can use the `recipe` macro to
  # configure which recipe to run when this model is saved.
  #
  #   class NginxSite < Hibachi::Model
  #     attr_accessor :host
  #     recipe :nginx_site
  #   end
  #
  # This extremely basic model definition is a valid, working Hibachi
  # model. As long as you have a Hash in your attributes that can be
  # keyed at `:network_interfaces`, you can save this model and expect
  # that Chef will be updated.
  #
  # == Collection models
  #
  # You can also use collections to add and remove elements from a
  # collection of hashes in Chef attributes.
  #
  #   class NetworkInterface < Hibachi::Model
  #     attr_accessor :name
  #     recipe :network_interfaces, collection: true
  #   end
  #
  # This allows you to run `NetworkInterface.create()`.
  class Model
    include ActiveModel::Model
    include Recipe
    include Collection

    # The callback lifecycle in the model is as follows:
    #
    # - before_validation
    # - validations
    # - after_validation
    # - before_save
    # - before_{update|create}
    # - before_chef
    # - after_chef
    # - after_{update|create}
    # - after_save
    #
    # It adheres to the same order of operations that the model goes
    # through, which is to first update the Chef Server and local object
    # with the new attributes, and then run Chef on the box.
    define_model_callbacks :save, :update, :chef

    attr_reader :attributes

    # Configure all attribute methods on the instance of this model.
    def initialize(attributes={})
      super
      @attributes = attributes
    end

    # Simply reload all attrs from the Chef server.
    def self.fetch
      new.reload!
    end

    # Update the current node and run Chef.
    def save
      run_callbacks :save do
        update_server and run_chef
      end
    end

    # Write the attributes as pulled down from the Chef server to memory
    # on this object.
    def reload!
      write attributes_from_chef_server
      self
    end

    # Update all attributes and save to the current node.
    def update_attributes(to_new_attributes={})
      write(to_new_attributes) and save
    end

    # Accessor for the Chef Server, which 
    def self.chef_server
      @chef_server = ChefServer.connect
    end

    def self.node
      chef_server.current_node
    end

    private
    def update_server
      run_callbacks :update do
        logger.debug "Updating node config for #{namespace} => #{attributes.to_json}"
        node.update_attributes namespace => node_attributes
      end
    end

    def run_chef
      run_callbacks :chef do
        ChefRunner.run recipe, in_background_if_configured
      end
    end

    def write(new_attributes={})
      @attributes.merge! new_attributes
      attributes.each do |key, value|
        writer = "#{key}="
        send writer, value if respond_to? writer
      end
      valid?
    end

    def in_background_if_configured
      { background: Hibachi.config.run_chef_in_background }
    end

    def attributes_from_chef_server
      if namespace.present?
        chef_server.current_node.attributes[cookbook][namespace]
      else
        chef_server.current_node.attributes[cookbook]
      end
    end
  end
end
