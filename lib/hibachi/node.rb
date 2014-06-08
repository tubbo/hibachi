module Hibachi
  # Interaction object with the Chef JSON. This class is used to write
  # to and read from the configuration on disk, which is also used by
  # Chef to manage machine configuration. It's called "Node" because
  # that's what Chef Server calls each of the servers it's deploying
  # your code to.
  #
  # All operations on this class are "hard", that is, they will actually
  # write data out to the config file.
  class Node
    include ActiveModel::Model
    include Enumerable

    attr_accessor :attributes, :file_path

    validates :file_path, presence: true

    validate :file_exists
    validate :has_cookbook_attributes

    # Derive config from file at given path.
    def self.find at_path=""
      node = new file_path: at_path
      node.valid?
      node
    end

    # Test if the specified file we're supposed to manipulate does in
    # fact exist.
    def exists?
      @exists ||= File.exists? file_path
    end
    alias present? exists?

    # Iterate through all attributes.
    def each
      attributes.each { |attr| yield attr }
    end

    delegate :empty?, :to => :attributes
    delegate :any?, :to => :attributes

    # Find the attribute at a given key.
    def [] key
      attributes[key]
    end

    # Set the attribute at a given key.
    def []= key, value
      merge! key => value
    end

    # Merge incoming Hash with the Chef JSON.
    def merge! with_new_attributes={}
      attributes.merge! with_new_attributes
      update!
    end

    # Delete an attribute from the Hash and write JSON.
    def delete id
      attributes.delete id
      update!
    end

    # Attributes as initially populated by the parsed JSON file. Scoped
    # by the global cookbook.
    def attributes
      @attributes ||= parsed_json_attributes[Hibachi.config.cookbook] || {}
    end

    delegate :any?, :to => :attributes
    delegate :empty?, :to => :attributes

    protected
    # All attributes as parsed from the Chef JSON.
    def parsed_json_attributes
      JSON.parse(chef_json).with_indifferent_access
    end

    private
    def chef_json
      @raw_json ||= File.read file_path
    end

    def update!
      File.write file_path, pretty_formatted_json
      true
    rescue StandardError => exception
      logger.error exception.message
      exception.backtrace.each { |line| logger.error line }
      false
    end

    def pretty_formatted_json
      JSON.pretty_generate Hibachi.config.cookbook => attributes
    end

    def file_exists
      errors.add :file, "'#{file_path}' does not exist" unless exists?
    end

    def has_cookbook_attributes
      errors.add :cookbook, "could not be parsed from JSON" unless any?
    end
  end
end
