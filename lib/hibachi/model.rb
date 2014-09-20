require 'active_model'

require 'hibachi/model/recipe'
require 'hibachi/model/collection'
require 'hibachi/model/node_attributes'

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
    include NodeAttributes

    # Define callbacks for the model persistence lifecycle.
    #
    # - before_validation
    # - after_validation
    # - before_save
    # - before_{update|create}
    # - before_upload
    # - after_upload
    # - before_converge
    # - after_converge
    # - after_{update|create}
    # - after_save
    #
    # It adheres to the same order of operations that the model goes
    # through, which is to first update the Chef Server and local object
    # with the new attributes, and then run Chef on the box.
    define_model_callbacks :validation, :save, :create, :update, :upload, :converge

    attr_reader :attributes

    # Configure all attribute methods on the instance of this model.
    def initialize(attributes={})
      super
      @attributes = attributes
    end

    # Instantiate a new model object and load it with attributes from
    # the Chef server.
    def self.fetch
      new.reload!
    end

    # Run validations and callbacks before and after validation. Returns
    # `true` if no errors are found after all validators are run.
    def valid?
      run_callbacks :validation do
        super
      end
    end

    # Tests whether this attribute record is in the current node
    # attributes. If the model is not configured to be a collection,
    # this always returns false.
    def new_record?
      return false unless collection?
      not persisted?
    end

    # Tests whether the attributes in this class are equal to the
    # attributes on the ChefServer.
    def persisted?
      if collection?
        attributes_from_chef_server[id] == attributes
      else
        attributes_from_chef_server == attributes
      end
    end

    # Update the current node and run Chef.
    def save
      return false unless valid?
      run_callbacks :save do
        create if new_record?
        upload and converge
      end
    end

    # Update all attributes and save to the current node.
    def update_attributes(to_new_attributes={})
      run_callbacks :update do
        write(to_new_attributes) and save
      end
    end

    # Write the attributes as pulled down from the Chef server to memory
    # on this object, and then return the model object itself.
    def reload!
      write attributes_from_chef_server
      self
    end

    private
    # Run callbacks for uploading and upload node configuration to the
    # Chef server.
    def upload
      run_callbacks :upload do
        logger.debug "Updating node config for #{namespace} => #{attributes.to_json}"
        upload!
      end
    end

    # Run callbacks for convergence and converge this node with
    # Chef::Client.
    def converge
      run_callbacks :converge do
        logger.debug "Converging node"
        converge!
      end
    end

    # Merge the given hash of attributes with the object's attributes
    # hash, and write values to each setter that exists.
    def write(new_attributes={})
      @attributes.merge! new_attributes

      attributes.each do |key, value|
        writer = "#{key}="
        send writer, value if respond_to? writer
      end

      true # always continue forward
    end

    def in_background_if_configured
      { background: Hibachi.config.run_chef_in_background }
    end
  end
end
