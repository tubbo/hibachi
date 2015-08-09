require "rails/engine"

module Hibachi
  # Hooks into the Rails application.
  class Engine < Rails::Engine
    isolate_namespace Hibachi

    config.eager_load_namespaces << Hibachi
  end
end
