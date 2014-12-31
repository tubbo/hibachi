require 'ridley'
require 'active_model'

module Hibachi
  # Interaction object with the Chef Zero server. This class is used to write
  # to and read from the local node attribute configuration used by
  # Chef to manage machine configuration.
  class Node
    attr_accessor :name

    attr_reader :attributes

    def initialize(name)
      @name = name
      @attributes = chef.node.find(name).attributes
    end

    def self.find(by_name)
      new(by_name) if exists?(by_name)
    end

    def self.exists?(name)
      chef.node.find(name).present?
    end

    def self.chef
      @chef ||= Ridley.new Hibachi.client_settings
    end

    def []=(key, value={})
      set key, value
    end

    def [](key)
      get key
    end

    def update_attributes(params={})
      set(params) and save
    end

    def save
      if valid?
        node = chef.node.find(name)
        node.attributes = node.attributes.merge(attributes)
        chef.update node
      else
        false
      end
    end

    def set(recipe, params)
      @attributes = self.attributes.merge(recipe => params)
    end

    def get(recipe)
      self.attributes[recipe]
    end

    private

    def chef
      self.class.chef
    end
  end
end
