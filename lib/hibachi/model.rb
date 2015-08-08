module Hibachi
  class Model
    include ActiveAttr::Model

    extend Enumerable

    class_attribute :plural, default: false

    def initialize(params = {}, id = nil)
      return super unless id.present?
      super params.merge id: id
    end

    def self.field(name, type: String, default: nil)
      property name, type: type, default: default
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

    delegate :[], :[]=, to: :attributes

    field :id, type: Integer

    def save
      valid? && update
    end

    def to_param
      plural? ? id : param_name
    end

    def plural?
      self.class.plural || false
    end

    def persisted?
      id.present?
    end

    def new_record?
      not persisted?
    end

    private

    def update
      all.update param_name, attributes, id: id
    end

    def param_name
      self.class.model_name.param_name
    end
  end
end
