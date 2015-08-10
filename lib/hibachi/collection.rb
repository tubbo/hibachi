module Hibachi
  # Collection object which also stores the connection to the Node
  # resource.
  class Collection
    include Enumerable

    # Model class that this collection needs to work with.
    #
    # @attr_reader [Class]
    attr_reader :model

    # Param key for the model we are using to key node attributes by.
    #
    # @attr_reader [String]
    attr_reader :param

    # @param [ActiveModel::Name] model_name
    def initialize(model_name)
      @model = model_name.to_s.constantize
      @param = model_name.param_key
    end

    # Implement +Enumerable+ on this object.
    #
    # @return [Iterator]
    delegate :each, to: :models

    # Find a given model by its ID, or return +nil+ if none can be
    # found. For non-pluralized models, just return a new model object
    # with all of the node's attributes. In these non-plural cases,
    # +find+ can be called without any arguments.
    #
    # @param [Integer] id
    # @return [Model] or +nil+ if none can be found.
    def find(id = nil)
      model.new(node.attributes) unless model.pluralized
      models.find { |model| model.id == id }
    end

    # Search over the collection of models and check if all of the
    # params match any given model. If so, return it back in another
    # collection.
    #
    # @param [Hash] params
    # @return [Array<Model>]
    def where(params = {})
      select do |model|
        params.all? do |attribute, param_value|
          model[attribute] == param_value
        end
      end
    end

    private

    # @private
    # @return [Array<Model>
    def models
      @models ||= node.attributes.map do |attributes|
        model.new attributes
      end
    end

    # @private
    # @return [Node]
    def node
      @node ||= Node.new(
        name: model.node_name,
        key: param
      )
    end
  end
end
