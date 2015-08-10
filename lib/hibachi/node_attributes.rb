module Hibachi
  # Massages attributes for the +Node+ class to re-insert back into the
  # Chef server. Merges attributes and IDs originating in model objects.
  #
  # @api private
  class NodeAttributes
    # ID of the item.
    #
    # @attr_reader [Integer]
    attr_reader :id

    # New parameters of the item.
    #
    # @attr_reader [Hash]
    attr_reader :params

    # Existing full node attributes.
    #
    # @attr_reader [Hash]
    attr_reader :attributes

    # @param [Integer] id (optional)
    # @param [Hash] params
    # @param [Hash] attributes
    def initialize(id, params, attributes)
      @id = id
      @params = params
      @attributes = attributes
    end

    # Pass all arguments to the +new+ method to instantiate this object,
    # then return its result as a +Hash+
    #
    # @param [Integer] id (optional)
    # @param [Hash] params
    # @param [Hash] attributes
    # @return [Hash]
    def self.merge(id = nil, params, attributes)
      new(id, params, attributes).result
    end

    # Test if this model has already been persisted to the database by
    # checking presence of an +id+ and an +index+. Only applicable on
    # pluralized models.
    #
    # @return [Boolean]
    def persisted?
      id.present? && index.present?
    end

    # Test if this model has not yet been persisted to the database by
    # checking presence of an +id+ and wheter +index+ is nil.
    # Only applicable on pluralized models.
    #
    # @return [Boolean]
    def new_record?
      id.present? && index.nil?
    end

    # Result of the merger between the given parameters and the existing
    # attributes.
    #
    # @return [Hash]
    def result
      case
      when persisted?
        @attributes[index] = attributes[index].merge(params)
        attributes
      when new_record?
        @attributes.push(params)
      else
        @attributes.merge(params)
      end
    end

    # Find the index of the item by its +id+. Returns +nil+ if none can
    # be found.
    #
    # @return [Integer] or +nil+ if the ID does not exist in the DB.
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
