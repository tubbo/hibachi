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
    class_attribute :node_name, default: Hibachi.config.node_name

    define_model_callbacks :save, :create, :update, :destroy

    def self.pluralized!
      self.pluralized = true
    end

    def self.create(params = {})
      model = new(params)
      model.save
      model
    end

    def self.all
      @collection ||= Collection.new model_name
    end

    alias_method :[],   :read_attribute
    alias_method :[]=,  :write_attribute

    attribute :id, type: Integer

    def save
      run_callbacks :save do
        valid? && (create || update)
      end
    end

    def to_param
      plural? ? id : param_name
    end

    def plural?
      self.class.plural || false
    end

    alias_method :persisted?, :id?

    def new_record?
      !persisted?
    end

    def update_attributes(new_attributes = {})
      new_attributes.all? do |name, value|
        self[name] = value
      end && save
    end

    private

    def create
      return unless new_record?
      run_callbacks(:create) { persist }
    end

    def update
      return unless persisted?
      run_callbacks(:update) { persist }
    end

    def persist
      node.update attributes, id: id
    end

    def node
      @node ||= Node.new(
        name: self.class.node_name,
        param: model_name.param_key
      )
    end
  end
end
