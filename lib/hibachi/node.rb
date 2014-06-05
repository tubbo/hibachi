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
    #validate :file_not_in_use

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

    # Test if the file is in use, in which case we do not want to write
    # to it.
    def in_use?
      @in_use ||= `lsof #{file_path}` == ""
    end

    # Iterate through all attributes.
    def each
      attributes.each { |attr| yield attr }
    end

    # Find the attribute at a given key.
    def [] key
      attributes[key]
    end

    # Set the attribute at a given key.
    def []= key, value
      attributes.merge key => value
      update!
    end

    # Merge incoming Hash with the Chef JSON.
    def merge with_new_attributes={}
      attributes.merge with_new_attributes
      update!
    end

    # Delete an attribute from the Hash and write JSON.
    def delete id
      attributes.delete id
      update!
    end

    # All attributes as parsed from the Chef JSON.
    def attributes
      @attributes ||= JSON.parse(chef_json).with_indifferent_access
    end

    private
    def chef_json
      @raw_json ||= File.read file_path
    end

    def update!
      File.write file_path, attributes.to_json
    end

    def file_exists
      errors.add :file, "'#{file_path}' does not exist" unless exists?
    end

    def file_not_in_use
      errors.add :file, "'#{file_path}' is in use" if in_use?
    end
  end
end
