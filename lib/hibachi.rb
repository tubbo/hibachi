require 'ridley'

require 'hibachi/version'
require 'hibachi/configuration'
require 'hibachi/model'

module Hibachi
  extend Configuration

  # Connection to the Chef Server.
  def self.client_settings
    {
      server_url: 'http://localhost:9292',
      client_name: 'app',
      client_key: '/etc/chef/client.pem'
    }
  end
end
