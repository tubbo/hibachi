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
      if Hibachi.config.run_in_background
        raise InstallActiveJobError unless using_active_job?
        require 'hibachi/job' # we must require it here "conditionally"
        Hibachi::Job.enqueue self
      else
        Hibachi.run_chef recipe
      end
    end

    def chef_json
      ChefJSON.fetch
    end

    def using_active_job?
      defined? ActiveJob::Base
    end
  end

  class InstallActiveJobError < StandardError
    def initialize
      @message = %{
        You must install ActiveJob to run Chef in the background..

        <https://github.com/rails/activejob>
      }
    end
  end
end
