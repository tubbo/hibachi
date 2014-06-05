require 'rails/railtie'

module Hibachi
  # Default Rails config for the engine.
  class Railtie < Rails::Railtie
    config.hibachi = ActiveSupport::OrderedOptions.new

    # Configure where the Chef JSON will be stored, by default it's
    # located in the Rails config dir.
    config.hibachi.chef_json_path = "#{Rails.root}/config/chef.json"

    # Configure where to look for the Chef repo.
    config.hibachi.chef_dir = "#{Rails.root}/config/chef"

    # Configure where the log file will be kept of all Chef runs, by
    # default it's located in the Rails log dir.
    config.hibachi.log_path = "#{Rails.root}/log/hibachi.log"

    # If you're using ActiveJob, Hibachi can trigger Chef runs to queue
    # in the background. Just flip this flag to `true` and get
    # backgrounding for free.
    config.hibachi.run_in_background = false

  end
end
