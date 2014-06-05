require 'hibachi/chef_json'

module Hibachi
  module Persistence
    def create
      write_config and run_chef
    end
    alias update create

    def destroy
      chef_json.delete id
    end

    private
    def write_config
      chef_json.merge attributes
    end

    def run_chef
      Hibachi.run_chef recipe
    end

    def chef_json
      ChefJSON.fetch
    end
  end
end
