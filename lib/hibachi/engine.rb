require "rails/engine"

module Hibachi
  class Engine < Rails::Engine
    USER = ENV['USER']
    HOME = ENV['HOME']

    isolate_namespace Hibachi

    config.eager_load_namespaces << Hibachi

    config.hibachi = ActiveSupport::OrderedOptions.new

    config.hibachi.org_name = 'waxpoetic'
    config.hibachi.server_url = "https://api.chef.io/organizations/#{config.hibachi.org_name}"
    config.hibachi.client_name = USER
    config.hibachi.client_key_path = File.join(HOME, '.chef', "#{USER}.pem")
    config.hibachi.node_name = 'hibachi'
  end
end
