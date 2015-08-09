module Hibachi
  # Data model for a node on the Chef server.
  class Node
    # @attr_reader [String]
    attr_reader :name

    # @attr_reader [String]
    attr_reader :key

    # @param [String] name - Name of this node on the Chef server
    # @param [String] key - Attribute key this object manipulates
    def initialize(name: Hibachi.config.node_name, key: '')
      @name = name
      @key = key
    end

    # Update the attributes hash for this node.
    #
    # @param [Integer] id - (optional) ID of the resource for plurals.
    # @param [Hash] params - New attributes to merge in.
    # @return [Boolean]
    def update(id: nil, params: {})
      current_node.update attributes: merge(id, params)
    end

    private

    # @private
    # @param [Integer] id (optional)
    # @param [Hash] new_attributes
    # @return [Hash]
    def merge(id, new_attributes)
      current_attributes(id).merge(new_attributes)
    end

    # @private
    # @param [Integer] id (optional)
    def current_attributes(id: nil)
      return node_attributes[id] if id.present?
      node_attributes
    end

    # @private
    # @return [Hash]
    def node_attributes
      node.attributes[key]
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
