require 'hibachi/install_active_job_error'

module Hibachi
  module ChefRunner
    # Runs the local Chef::Solo client for the given recipe. Loads the
    # configuration specified at `Hibachi.config.chef_json_path` as
    # Chef JSON, running only the given recipe name as specified in the
    # method call. Used by the model backend to run Chef when they are
    # updated, so configuration stays up to date with the JSON
    # configuration.
    def run_chef recipe, options={}
      run_chef_in_bg(recipe) and return true if options[:background]
      run "touch #{config.log_path}" unless File.exists? config.log_path
      log "Running Chef for '#{recipe}' at '#{Time.now}'..." and
      chef "-r '#{recipe_name(recipe)}' -J #{config.chef_json_path}"
    end

    private
    def run_chef_in_bg recipe
      raise InstallActiveJobError unless using_active_job?
      require 'hibachi/job' # we must require it here "conditionally"
      Hibachi::Job.enqueue self
    end

    def using_active_job?
      defined? ActiveJob::Base
    end

    def chef options
      run %(cd #{config.chef_dir} && chef-solo -l debug #{options})
    end

    def log message
      run %(echo "#{message}" >> #{config.chef_json_path})
    end

    def run command
      `#{command}` and $?.success?
    end

    def recipe_name name
      return "recipe[#{name}]" if name =~ /\:\:/
      "recipe[#{name}::default]"
    end
  end
end
