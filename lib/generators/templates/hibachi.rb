require 'hibachi'

# Configure global Hibachi settings here, such as the location of the log file
# and Chef JSON file. You my also use the Rails config to manipulate
# these settings, as all configuration data is stored in the
# `Rails.application.config.hibachi` namespace.

Hibachi.configure do |config|
  #config.chef_json_path = "#{Rails.root}/config/chef.json"
  #config.log_path = "#{Rails.root}/log/hibachi.log"
end
