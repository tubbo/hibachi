module Hibachi
  class NodeAttributes
    attr_reader :id, :params, :attributes

    def initialize(id = nil, params, attributes)
      @id = id
      @params = params
      @attributes = attributes
    end

    def self.merge(*args)
      new(*args).result
    end

    def persisted?
      id.present? && index.present?
    end

    def new_record?
      id.present? && index.nil?
    end

    def result
      case
      when persisted?
        self.attributes[index] = attributes[index].merge(params)
        self.attributes
      when new_record?
        self.attributes.push(params)
      else
        self.attributes.merge(params)
      end
    end

    private

    def index
      index_of_item = nil

      attributes.each_with_index do |attribute, position|
        if attribute[:id] == id
          index_of_item = position
          break
        end
      end

      index_of_item
    end
  end
end
