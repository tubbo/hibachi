require 'hibachi/install_active_job_error'
require 'active_model/model'

module Hibachi
  class Converger
    include ActiveModel::Model

    # The recipe name that is to be run.
    attr_accessor :recipe

    # Any additional options this class needs.
    attr_writer :params

    # The base command we'll be using to run Chef. It used to be
    # `chef-solo`, but with the recent push on `chef-zero`, it can now
    # run the client as long as a chef-zero instance is available and
    # running.
    CHEF_CMD = 'chef-client'

    # Runs the local Chef::Client for the given recipe.
    def self.run recipe, options={}
      converger = new recipe: recipe, params: options
      converger.chef!
      converger
    end

    # Run Chef on the instance of this runner.
    def converge!
      return true unless should_run?
      run_chef_in_background and return true if background?
      ensure_config_exists and run_chef
    end

    # Test whether we should run Chef in the background by enqueuing a
    # job.
    def background?
      !!params[:background]
    end

    # Test whether we should run Chef at all.
    def should_run?
      Hibachi.config.run_chef
    end

    # Ensure params come back as a HashWithIndifferentAccess.
    def params
      @params_with_indifferent_access = @params.try :with_indifferent_access
    end

    private
    def run_chef_in_background
      raise InstallActiveJobError unless using_active_job?
      require 'hibachi/job' # we must require it here "conditionally"
      Hibachi::Job.enqueue self
    end

    def ensure_config_exists
      run "touch #{config.log_path}"
      log "Running Chef for '#{recipe}' at '#{Time.now}'..."
    end

    def run_chef
      chef "--run-list=#{recipe_name} --local-mode --log-level=debug"
    end

    def using_active_job?
      defined? ActiveJob::Base
    end

    def chef options
      run %(cd #{config.chef_dir} && #{COMMAND} -l debug #{options})
    end

    def log message
      run %(echo "#{message}" >> #{config.chef_json_path})
    end

    def run command
      `#{command}` and $?.success?
    end

    def recipe_name
      "recipe[#{recipe}]"
    end
  end
end
