require "active_support/dependencies/autoload"
require "active_support/configurable"

require "hibachi/version"

module Hibachi
  extend ActiveSupport::Autoload

  include ActiveSupport::Configurable

  autoload :Model
  autoload :Collection

  def self.config
    Rails.application.config.hibachi
  end

  def self.client
    @client ||= Ridley.new config.to_h.slice(
      :server_url, :client_name, :client_key
    )
  end

  def self.node
    client.nodes.find config.node_name
  end
end
