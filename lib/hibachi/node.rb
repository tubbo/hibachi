module Hibachi
  # Data model for a node on the Chef server. Maintains connectivity via
  # the private Ridley client and a node object discovered by either the
  # passed-in node name or the default configuration.
  class Node
    # @attr_reader [String]
    attr_reader :name

    # @attr_reader [String]
    attr_reader :key

    # @param [String] name - Name of this node on the Chef server
    # @param [String] key - Attribute key this object manipulates
    def initialize(name: '', key: '')
      @name = name
      @key = key
    end

    # All attributes for this node, scoped by the given param key.
    #
    # @return [Hash]
    def attributes
      node.attributes[key]
    end

    # Update the attributes hash for this node.
    #
    # @param [Integer] id - (optional) ID of the resource for plurals.
    # @param [Hash] params - New attributes to merge in.
    # @return [Boolean]
    def update(id: nil, params: {})
      node.update attributes: merge(id, params)
    end

    private

    # @private
    # @param [Integer] id (optional)
    # @param [Hash] params
    # @return [Hash]
    def merge(id, params)
      NodeAttributes.merge id, params, attributes
    end

    # @private
    # @return [Ridley::NodeResource]
    def node
      @node ||= client.nodes.find(name)
    end

    # @private
    # @return [Ridley::Client]
    def client
      @client ||= Ridley.new config
    end

    # @private
    # @return [Hash]
    def config
      Hibachi.config.to_h.slice :server_url, :client_name, :client_key
    end
  end
end
