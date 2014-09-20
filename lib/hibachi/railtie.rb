require 'rails/railtie'

module Hibachi
  # Hibachi's configuration, available as a Railtie.
  class Railtie < Rails::Railtie
    config.hibachi = ActiveSupport::OrderedOptions.new

    # Configure whether to run Chef at all during changes. This is best
    # set to `false` in development and test.
    config.hibachi.run_chef = true

    # Chef Server Connection Settings
    #
    # It's recommended that one does not connect directly to their own
    # Chef Server, but rather a Chef Zero implementation on the same
    # box or a shared Chef Server between multiple installations. The
    # application's configuration should be allowed to be overridden.
    config.hibachi.chef = {
      server_url: '127.0.0.1:5986',
      client_name: 'hibachi',
      client_key: "#{Rails.root}/config/chef/client.pem"
    }

    # This should probably be changed to the actual FQDN of this node.
    config.hibachi.node_name = 'hibachi.psychedeli.ca'

    # Where to look for the cookbook.
    config.hibachi.cookbook_path = "#{Rails.root}/config/chef/cookbook"

    # A path to the node JSON that will be stored in the application for
    # safe keeping.
    config.hibachi.node_path = "#{Rails.root}/config/chef/node.json"

    # Configure where the log file will be kept of all Chef runs, by
    # default it's located in the Rails log dir.
    config.hibachi.log_path = "#{Rails.root}/log/hibachi.log"

    # If you're using ActiveJob, Hibachi can trigger Chef runs to queue
    # in the background. Just flip this flag to `true` and get
    # backgrounding for free.
    #
    # NOTE: If you set this to `true` and you don't have ActiveJob
    # installed, Hibachi will throw an error whenever you try and run
    # Chef.
    config.hibachi.run_in_background = false
  end
end
