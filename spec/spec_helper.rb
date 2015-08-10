# Load the Hibachi gem
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hibachi'

# Load Rails environment from the dummy app
ENV["RAILS_ENV"] = "test"
# require File.expand_path("../../spec/dummy/config/environment.rb", __FILE__)
# require 'rspec/rails'
require "active_attr/rspec"
require 'pry'
require 'codeclimate-test-reporter'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Hibachi.configure do |config|
  config.server_url = "https://api.chef.io/organizations/waxpoetic"
  config.node_name = "hibachi"
  config.client_name = "tubbo"
  config.client_key = File.expand_path("../.chef/tubbo.pem", __FILE__)
end

# Use dummy app migrations
# ActiveRecord::Migrator.migrations_paths = [
#   File.expand_path("../../spec/dummy/db/migrate", __FILE__)
# ]

# # Configure RSpec
# RSpec.configure do |config|
#   config.global_fixtures = :all
# end

CodeClimate::TestReporter.start
