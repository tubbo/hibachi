require 'hibachi/railtie'

module Hibachi
  # Methods for manipulating Hibachi's configuration settings, which are
  # actually stored in the Rails config. This module is meant to be
  # extend'ed onto the Hibachi main module.
  module Configuration
    # Manipulate the Hibachi configuration.
    def configure
      yield config
    end

    # Shorthand access to the entire Hibachi configuration.
    def config
      Rails.application.config.hibachi
    end
  end
end
