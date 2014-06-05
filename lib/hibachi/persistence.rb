require 'hibachi/chef_json'
require 'hibachi/job'

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
      if Hibachi.config.run_in_background
        Hibachi::Job.enqueue self
      else
        Hibachi.run_chef recipe
      end
    end

    def chef_json
      ChefJSON.fetch
    end
  end
end
