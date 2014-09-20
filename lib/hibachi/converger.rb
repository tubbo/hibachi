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
    COMMAND = 'chef-client'

    # Runs the local Chef::Client for the given recipe, in the
    # background if that option is `true`.
    def self.run recipe, options={}
      converger = new recipe: recipe, params: options
      converger.run
      converger
    end

    # Run Chef on the instance of this runner.
    def run
      return true unless should_run?
      ensure_log_exists
      if background?
        run_chef_in_background
      else
        run_chef
      end
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

    def ensure_log_exists
      run "touch #{Hibachi.config.log_path}"
      logger.debug "Started logging convergence at #{Time.now}"
    end

    def run_chef
      logger.info "Running Chef for '#{recipe}' at '#{Time.now}'..."
      chef "--run-list=#{run_list} --local-mode --log-level=debug"
    end

    def using_active_job?
      defined? ActiveJob::Base
    end

    def chef options
      run "#{COMMAND} #{options} >> #{log_path}"
    end

    def logger
      @logger ||= Logger.new log_path
    end

    def log_path
      @log_path ||= Hibachi.config.log_path
    end

    def run command
      `#{command}`
      $?.success?
    end

    def run_list
      "recipe[#{recipe}]"
    end
  end
end
