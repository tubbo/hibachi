Hibachi.configure do |config|
  config.server_url = "https://api.chef.io/organizations/waxpoetic"
  config.node_name = "hibachi"
  config.client_name = "tubbo"
  config.client_key = File.expand_path("../.chef/tubbo.pem", __FILE__)
end
