module Hibachi
  # Methods for running Chef on the box.
  module ChefRunner
    # Run Chef for the given recipe name.
    def run_chef recipe, options={}
      run_chef_in_bg(recipe) and return true if options[:background]
      run "touch #{config.log_path}" unless File.exists? config.log_path
      log "Running Chef for '#{recipe}' at '#{Time.now}'..." and
      chef "-r '#{name_of(recipe)}' -J #{config.chef_json_path}"
    end

    class InstallActiveJobError < StandardError
      def initialize
        @message = %{
          You must install ActiveJob to run Chef in the background..

          <https://github.com/rails/activejob>
        }
      end
    end

    private
    def run_chef_in_bg recipe
      raise InstallActiveJobError unless using_active_job?
      require 'hibachi/job' # we must require it here "conditionally"
      Hibachi::Job.enqueue self
    end

    def chef(options)
      run %(chef-client -l debug #{options})
    end

    def log(message)
      run %(echo "#{message}" >> #{config.chef_json_path})
    end

    def run(command)
      `#{command}` and $?.success?
    end

    def recipe_name name
      return "recipe[#{name}]" if name =~ /\:\:/
      "recipe[#{name}::default]"
    end
  end
end
