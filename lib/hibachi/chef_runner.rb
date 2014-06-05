module Hibachi
  # Methods for running Chef on the box.
  module ChefRunner
    # Run Chef for the given recipe name.
    def run_chef recipe
      run "touch #{config.log_path}" unless File.exists? config.log_path
      log "Running Chef for '#{recipe}' at '#{Time.now}'..."
      chef "-r '#{name_of(recipe)}' -J #{config.chef_json_path}"
    end

    private
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
      return "recipe[#{name}]" if name =~ /::default\Z/
      "recipe[#{name}::default]"
    end
  end
end
