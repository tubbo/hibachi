require 'hibachi/version'
require 'hibachi/configuration'
require 'hibachi/chef_runner'
require 'hibachi/model'

module Hibachi
  extend ChefRunner
  extend Configuration
end
