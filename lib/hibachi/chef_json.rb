module Hibachi
  class ChefJSON
    attr_reader :path

    include Enumerable

    def initialize from_path=""
      @path = from_path
    end

    def each
      attributes.each { |attr| yield attr }
    end

    def self.fetch
      new '/etc/chef.json'
    end

    def [] key
      attributes[key]
    end

    def []= key, value
      attributes.merge key => value
      update!
    end

    def merge with_new_attributes={}
      attributes.merge with_new_attributes
      update!
    end

    def delete id
      attributes.delete id
      update!
    end

    private
    def update!
      File.write path, attributes.to_json
    end
