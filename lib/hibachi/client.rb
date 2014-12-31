module Hibachi
  # Represents a Chef client run on the local machine.
  class Client
    # Converge a node right now using the loaded
    # ActiveSupport::OrderedOptions object. By default, we load the
    # hibachi object within the Rails config.
    def self.converge!(from_ordered_options = Rails.application.config.hibachi)
      new(from_ordered_options).converge
    end

    # Internal: Where we store the AS::OrderedOptions
    attr_reader :config

    # Internal: Set up the configuration for this client run.
    def initialize(config)
      @config = config
    end

    # Internal: Converge this node with Chef.
    def converge
      chef.run
    end

    private

    # Internal: The Chef client instance.
    def chef
      Chef::Client.new(
        'run_list' => [config.cookbook],
        'log_level' => config.log_level,
        'log_path' => config.log_path
      )
    end
  end
end
