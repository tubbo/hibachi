require 'rails/railtie'

module Hibachi
  # Default Rails config for the engine.
  class Railtie < Rails::Railtie
    config.hibachi = ActiveSupport::OrderedOptions.new

    # The name of the cookbook we'll be converging.
    config.hibachi.cookbook = nil

    # Configure where the Chef JSON will be stored, by default it's
    # located in the Rails config dir.
    config.hibachi.chef_json_path = "#{Rails.root}/config/chef.json"

    # Configure where to look for the Chef repo.
    config.hibachi.chef_dir = "#{Rails.root}/config/chef"

    # When running Chef, log output to a particular file on disk. Use
    # the default log_level in Rails.
    config.hibachi.log_path = "#{Rails.root}/log/hibachi.log"
    config.hibachi.log_level = :info
  end
end
