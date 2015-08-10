module Hibachi
  # Base class for Chef-driven model objects in the Rails app.
  #
  # @example Defining a new model
  #   class NetworkInterface < Hibachi::Model
  #     pluralized!
  #
  #     field :name
  #   end
  #
  # @example Creating a new record
  #   NetworkInterface.create name: 'eth0'
  #
  # @example Updating an existing record
  #   iface = NetworkInterface.find_by name: 'eth0'
  #   iface.update_attributes name: 'eth1'
  #   iface.name # => 'eth1'
  class Model
    include ActiveAttr::Model

    extend Enumerable

    class_attribute :pluralized, default: false
    class_attribute :_node_name, default: Hibachi.config.node_name

    define_model_callbacks :save, :create, :update, :destroy

    class << self
      # Configure this to be representing a pluralized model resource.
      def pluralized!
        self.pluralized = true
      end

      # Configure a custom node to send attributes to.
      #
      # @param [String] custom_node_name
      def node_name(custom_node_name = "")
        self._node_name = custom_node_name
      end

      # Create a new resource
      #
      # @param [Hash] params
      def create(params = {})
        model = new(params)
        model.save
        model
      end

      # Return all saved resources in a pluralized collection.
      #
      # @return [Collection]
      def all
        @collection ||= Collection.new model_name
      end

      # Implement +Enumerable+.
      delegate :each, to: :all
    end

    # Allow reading of attributes like a Hash.
    #
    # @example
    #   model = Model.new name: 'test'
    #   model[:name] # => 'test'
    alias_method :[],   :read_attribute

    # Allow writing of attributes like a Hash.
    #
    # @example
    #   model = Model.new name: 'test'
    #   model[:name] = "new test"
    #   model.name # => 'new test'
    alias_method :[]=,  :write_attribute

    # Always include an +id+ parameter.
    #
    # @return [Integer]
    attribute :id, type: Integer

    # Validate then persist this model to the Chef server.
    #
    # @return [Boolean]
    def save
      run_callbacks :save do
        valid? && (create || update)
      end
    end

    # Use the +id+ attribute when this model is pluralized, and the
    # default +param_key+ otherwise, to represent it in a URL or other
    # kind of parameter-based String.
    #
    # @return [String]
    def to_param
      plural? ? id : model_name.param_key
    end

    # Test the class-level configuration for whether this model should
    # be pluralized or not (e.g., should it have an ID and be placed in
    # a collection rather than bare attributes?), or returns +false+ by
    # default.
    #
    # @return [Boolean]
    def plural?
      self.class.pluralized || false
    end

    # A model is considered "persisted" if there is an +id+ present and
    # it's pluralized, or if the node attributes on Chef match up with
    # Hash in this class otherwise.
    #
    # @return [Boolean]
    def persisted?
      plural? ? id? : attributes == node.attributes
    end

    # Returns +true+ if this record has not yet been persisted.
    #
    # @return [Boolean]
    def new_record?
      !persisted?
    end

    # Updates all attributes locally and then saves them to the Chef
    # server.
    #
    # @return [Boolean] whether +save+ was successful.
    def update_attributes(new_attributes = {})
      new_attributes.all? do |name, value|
        self[name] = value
      end && save
    end

    private

    # @private
    # @return [Boolean]
    def create
      return unless new_record?

      run_callbacks :create do
        self.id = node.attributes.length + 1
        persist
      end
    end

    # @private
    # @return [Boolean]
    def update
      return unless persisted?

      run_callbacks :update do
        persist
      end
    end

    # @private
    # @return [Boolean]
    def persist
      node.update attributes, id: id
    end

    # @private
    # @return [Node]
    def node
      @node ||= Node.new(
        name: self.class._node_name,
        key: model_name.param_key
      )
    end
  end
end
