module Hibachi
  class Collection
    include Enumerable

    attr_reader :model, :param

    def initialize(model_name)
      @model = model_name.to_s.constantize
      @param = model_name.param_key
    end

    delegate :each, to: :models

    def find(id = nil)
      return model.new(node_attributes) unless id.present?
      models.find do |model_attributes|
        model_attributes['id'] == id
      end
    end

    def where(params = {})
      select do |model|
        params.all? do |attribute, param_value|
          model[attribute] == param_value
        end
      end
    end

    def update(param, attributes = {}, id: nil)
      existing, key = if id.present?
                   [ models, id ]
                 else
                   [ models, param ]
                 end

      node.update attributes: existing.merge(key => attributes)
    end

    private

    def models
      node_attributes.each do |id, attributes|
        model.new attributes, id
      end
    end

    def node_attributes
      node.attributes[param]
    end
  end
end
