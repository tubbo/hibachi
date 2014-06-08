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
      return true unless config.run_chef

      if options[:background]
        run_chef_in_bg(recipe) and return true
      else
        run "touch #{config.log_path}" and
        log "Running Chef for '#{recipe}' at '#{Time.now}'..." and
        chef "-r '#{recipe_name(recipe)}' -J #{config.chef_json_path}"
      end
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
      if name =~ /\:\:/
        "recipe[#{cookbook}::#{name}]"
      else
        "recipe[#{cookbook}::#{name}::default]"
      end
    end
  end
end
