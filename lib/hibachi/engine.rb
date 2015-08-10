require "rails/engine"

module Hibachi
  # Establish hooks into the Rails application by adding +Hibachi+ to
  # the +eager_load_namespaces+ configuration. This will eager-load
  # Hibachi along with the rest of the Rails app when applicable.
  class Engine < Rails::Engine
    isolate_namespace Hibachi

    config.eager_load_namespaces << Hibachi
  end
end
