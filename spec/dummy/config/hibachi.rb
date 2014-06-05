require 'hibachi'

Hibachi.configure do |config|
  config.chef_json_path = "#{Rails.root}/config/chef.json"
  config.log_file_path = "#{Rails.root}/log/chef.log"
end
