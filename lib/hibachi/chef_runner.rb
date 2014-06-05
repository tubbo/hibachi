module Hibachi
  # Methods for running Chef on the box.
  module ChefRunner
    CFG_PATH = '/etc/chef.json'
    LOG_PATH = '/var/log/hibachi.log'

    # Run Chef for the given recipe name.
    def run_chef recipe
      `touch #{LOG_PATH}` unless File.exists? LOG_PATH
      `echo "Running Chef for '#{recipe}' at '#{Time.now}'..." >> #{LOG_PATH}`
      `#{chef} -r '#{name_of(recipe)}' -J #{CFG_PATH} >> #{LOG_PATH}`
    end

    private
    def chef
      "chef-client -l debug"
    end

    def recipe_name name
      return "recipe[#{name}]" if name =~ /::default\Z/
      "recipe[#{name}::default]"
    end
  end
end
