require "active_support/all"
require "ridley"
require "active_attr"

require "hibachi/version"

# An object-resource mapper for your Chef server. Enables a Rails app to
# manipulate its own Chef node attributes and trigger a +chef-client+
# run on its local machine, as well as others.
module Hibachi
  extend ActiveSupport::Autoload

  include ActiveSupport::Configurable

  autoload :Engine
  autoload :Model
  autoload :Collection
  autoload :Node

  # URL to the Chef server.
  config_accessor :server_url

  # The client name we are connecting as on the Chef server.
  config_accessor :client_name

  # Path to the private key that allows us to connect as the
  # aforementioned client on the Chef server.
  config_accessor :client_key

  # Default node that we will be connecting to. You can override this by
  # passing +node_name 'foo'+ in your model class.
  config_accessor :node_name
end
