require 'spec_helper'

# Load Rails environment from the dummy app
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../../spec/dummy/config/environment.rb", __FILE__)
require 'rspec/rails'

# Use dummy app migrations
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path("../../../spec/dummy/db/migrate", __FILE__)
]

# Configure RSpec
RSpec.configure do |config|
  config.global_fixtures = :all
end
