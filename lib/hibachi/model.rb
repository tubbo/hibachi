require 'active_model'
require 'hibachi/persistence'
require 'hibachi/configuration'
require 'hibachi/querying'

module Hibachi
  class Model
    include ActiveModel::Model
    include Persistence
    include Configuration
    extend  Querying

    attr_accessor :attributes
  end
end
