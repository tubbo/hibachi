require 'hibachi'
require 'ridley'

module Hibachi
  # Proxy class for handling the Chef server through Ridley.
  class ChefServer
    class << self
      alias connect new
    end

    # Get the current node for this application.
    def current_node
      unless Hibachi.config.node_name.present?
        raise RuntimeError, "You must set config.hibachi.node_name"
      end

      @current_node ||= node.find Hibachi.config.node_name
    end

    def method_missing(method, *arguments)
      super unless respond_to? method
      connection.send method, *arguments
    end

    def respond_to?(method)
      connection.respond_to?(method) || super
    end

    private
    def connection
      @connection ||= Ridley.new Hibachi.config.chef
    end
  end
end
