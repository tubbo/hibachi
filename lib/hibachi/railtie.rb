require 'rails/railtie'

module Hibachi
  # Default Rails config for the engine.
  class Railtie < Rails::Railtie
    config.hibachi = ActiveSupport::OrderedOptions.new

    config.hibachi.chef_json_path = "#{Rails.root}/config/chef.json"
    config.hibachi.log_path = "#{Rails.root}/log/hibachi.log"
  end
end
