# Load the Hibachi gem
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hibachi'

# Load Rails environment from the dummy app
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../spec/dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require "active_attr/rspec"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Use dummy app migrations
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path("../../spec/dummy/db/migrate", __FILE__)
]

# Configure RSpec
RSpec.configure do |config|
  config.global_fixtures = :all
end
