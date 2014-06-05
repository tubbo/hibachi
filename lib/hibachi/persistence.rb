require 'hibachi/node'

module Hibachi
  module Persistence
    # Write the given attrs to config and re-run Chef.
    def create
      node.merge(attributes) and run_chef
    end
    alias update create

    # Remove the given id from the JSON and re-run Chef.
    def destroy id
      node.delete(id) and run_chef
    end

    private
    def run_chef
      if Hibachi.config.run_in_background
        run_chef_in_background!
      else
        Hibachi.run_chef recipe
      end
    end

    def node
      ChefJSON.fetch
    end

    def using_active_job?
      defined? ActiveJob::Base
    end

    def run_chef_in_background!
      raise InstallActiveJobError unless using_active_job?
      require 'hibachi/job' # we must require it here "conditionally"
      Hibachi::Job.enqueue self
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
