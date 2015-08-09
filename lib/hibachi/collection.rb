module Hibachi
  # Collection object which also stores the connection to the Node
  # resource.
  class Collection
    include Enumerable

    attr_reader :model
    attr_reader :param

    def initialize(model_name)
      @model = model_name.to_s.constantize
      @param = model_name.param_key
    end

    delegate :each, to: :models

    def find(id = nil)
      model.new(node_attributes) unless model.plural
      models.find { |model| model.id == id }
    end

    def where(params = {})
      select do |model|
        params.all? do |attribute, param_value|
          model[attribute] == param_value
        end
      end
    end

    private

    def models
      @models ||= node.attributes.map do |id, attributes|
        model.new attributes, id
      end
    end

    def node
      @node ||= Node.new param: param
    end
  end
end