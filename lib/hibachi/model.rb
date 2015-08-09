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
    include ActiveModel::MassAssignmentSecurity
    include ActiveModel::ForbiddenAttributesProtection

    extend Enumerable

    class_attribute :pluralized, default: false

    attr_reader :node

    def self.pluralized!
      self.pluralized = true
    end

    def self.field(name, type: String, default: nil)
      attribute name, type: type, default: default
    end

    def self.create(params = {})
      model = new(params)
      model.save
      model
    end

    def self.all
      @collection ||= Collection.new model_name
    end

    def self.method_missing(method, *arguments)
      return super unless respond_to?(method)
      all.send method, *arguments
    end

    def self.respond_to?(method)
      all.respond_to?(method) || super
    end

    alias_method :[],   :read_attribute
    alias_method :[]=,  :write_attribute

    field :id, type: Integer

    def save
      valid? && (create || update)
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
      @node ||= Node.new param: model_name.param_key
    end
  end
end
