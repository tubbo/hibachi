# Load the Hibachi gem
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'hibachi'
require "active_attr/rspec"
require 'pry'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
