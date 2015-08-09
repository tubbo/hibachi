require "active_support/all"
require "ridley"
require "active_attr"

require "hibachi/version"

# An object-resource mapper for your Chef server. Enables a Rails app to
# manipulate its own Chef node attributes and trigger a +chef-client+
# run on its local machine, as well as others.
module Hibachi
  extend ActiveSupport::Autoload
  extend ActiveSupport::Configurable

  autoload :Engine
  autoload :Model
  autoload :Collection
  autoload :Node

  config.org_name = 'waxpoetic'
  config.server_url = "https://api.chef.io/organizations/#{config.org_name}"
  config.client_name = ENV['USER']
  config.client_key_path = File.join(Rails.root, '.chef', "#{config.client_name}.pem")
  config.node_name = 'hibachi'
end
