require 'active_model'

require 'hibachi/model/recipe'
require 'hibachi/chef_runner'

module Hibachi
  # The model.
  class Model
    include ActiveModel::Model

    include Recipe

    attr_reader :attributes

    def initialize(attributes={})
      super
      @attributes = attributes
    end

    # Update the current node and run Chef.
    def save
      update and run_chef
    end

    # Update all attributes and save to the current node.
    def update_attributes(to_new_attributes={})
      write(to_new_attributes) and save
    end

    protected
    def chef_server
      @chef_server = ChefServer.connect
    end

    private
    def update
      logger.debug "Updating node config for #{cookbook} => #{attributes.to_json}"
      chef_server.current_node.update_attributes cookbook => attributes
    end

    def run_chef
      ChefRunner.run recipe, \
        background: Hibachi.config.run_chef_in_background
    end

    def write(new_attributes)
      @attributes.merge! new_attributes
      attributes.each do |key, value|
        writer = "#{key}="
        send writer, value if respond_to? writer
      end
    end
  end
end
